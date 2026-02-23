#!/usr/bin/env node
/**
 * Inserts a new <change> entry into repo.xml.tmpl based on conventional commits
 * since the previous release tag.
 *
 * Usage: node scripts/update-repo-changelog.js --version=X.Y.Z --prev-tag=X.Y.Z
 * Called by semantic-release via @semantic-release/exec prepareCmd.
 */
import { execSync } from 'child_process'
import { readFileSync, writeFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import { DOMParser, XMLSerializer } from '@xmldom/xmldom'
import { CommitParser } from 'conventional-commits-parser'

const __dirname = dirname(fileURLToPath(import.meta.url))
const REPO_NS = 'http://exist-db.org/xquery/repo'
const HTML_NS = 'http://www.w3.org/1999/xhtml'

function parseArgs () {
  return Object.fromEntries(
    process.argv.slice(2)
      .filter(a => a.startsWith('--') && a.includes('='))
      .map(a => {
        const eq = a.indexOf('=')
        return [a.slice(2, eq), a.slice(eq + 1)]
      })
  )
}

function tagExists (tag) {
  try {
    execSync(`git rev-parse "${tag}"`, { stdio: 'pipe' })
    return true
  } catch {
    return false
  }
}

function getCommits (prevTag) {
  const ref = tagExists(prevTag) ? prevTag
    : tagExists(`v${prevTag}`) ? `v${prevTag}`
      : null
  if (!ref) throw new Error(`Tag not found: ${prevTag} or v${prevTag}`)

  const hashes = execSync(`git log ${ref}..HEAD --format=%H`, { encoding: 'utf8' })
    .trim().split('\n').filter(Boolean)

  return hashes.map(hash => ({
    subject: execSync(`git log -1 --format=%s ${hash}`, { encoding: 'utf8' }).trim(),
    body: execSync(`git log -1 --format=%b ${hash}`, { encoding: 'utf8' }).trim()
  }))
}

const parser = new CommitParser({
  headerPattern: /^(\w*)(?:\(([^)]*)\))?(!)?:\s(.*)$/,
  headerCorrespondence: ['type', 'scope', 'breaking', 'subject'],
  noteKeywords: ['BREAKING CHANGE', 'BREAKING-CHANGE']
})

function buildChangeItems (commits) {
  const breaking = []
  const features = []
  const fixes = []

  for (const { subject, body } of commits) {
    const parsed = parser.parse(`${subject}\n\n${body}`)
    if (!parsed.type) continue

    const { type, scope, breaking: bang, subject: description, notes } = parsed
    const label = scope ? `${scope}: ${description}` : description
    const breakingNote = notes.find(n => n.title === 'BREAKING CHANGE' || n.title === 'BREAKING-CHANGE')

    if (bang || breakingNote) {
      breaking.push(breakingNote?.text || label)
    } else if (type === 'feat') {
      features.push(label)
    } else if (type === 'fix') {
      fixes.push(label)
    }
  }

  return [
    ...breaking.map(b => `Breaking change: ${b}`),
    ...features.map(f => `New: ${f}`),
    ...fixes.map(f => `Fix: ${f}`)
  ]
}

function insertChangeEntry (tmplPath, version, items) {
  const tmpl = readFileSync(tmplPath, 'utf8')
  const doc = new DOMParser().parseFromString(tmpl, 'text/xml')

  const changelog = doc.getElementsByTagNameNS(REPO_NS, 'changelog').item(0)
  if (!changelog) throw new Error('<changelog> not found in repo.xml.tmpl')

  // Build the new <change> element with proper indentation whitespace
  const change = doc.createElementNS(REPO_NS, 'change')
  change.setAttribute('version', version)
  change.appendChild(doc.createTextNode('\n            '))

  const ul = doc.createElementNS(HTML_NS, 'ul')
  for (const item of items) {
    ul.appendChild(doc.createTextNode('\n                '))
    const li = doc.createElementNS(HTML_NS, 'li')
    li.textContent = item
    ul.appendChild(li)
  }
  ul.appendChild(doc.createTextNode('\n            '))

  change.appendChild(ul)
  change.appendChild(doc.createTextNode('\n        '))

  // Find the first <change> element child to insert before it
  let firstChange = null
  for (let i = 0; i < changelog.childNodes.length; i++) {
    if (changelog.childNodes.item(i).nodeType === 1) {
      firstChange = changelog.childNodes.item(i)
      break
    }
  }

  // Insert new <change>, then a whitespace separator before the existing first <change>
  changelog.insertBefore(change, firstChange)
  changelog.insertBefore(doc.createTextNode('\n        '), firstChange)

  writeFileSync(tmplPath, new XMLSerializer().serializeToString(doc))
}

const { version, 'prev-tag': prevTag } = parseArgs()

if (!version || !prevTag) {
  console.error('Usage: update-repo-changelog.js --version=X.Y.Z --prev-tag=X.Y.Z')
  process.exit(1)
}

const commits = getCommits(prevTag)
const items = buildChangeItems(commits)

if (items.length === 0) {
  console.log(`No notable commits since ${prevTag}, skipping changelog update`)
  process.exit(0)
}

const tmplPath = join(__dirname, '..', 'repo.xml.tmpl')
insertChangeEntry(tmplPath, version, items)
console.log(`Added ${version} changelog entry to repo.xml.tmpl`)
