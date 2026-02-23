import { getXmlRpcClient, readOptionsFromEnv } from '@existdb/node-exist'
import { DOMParser } from '@xmldom/xmldom'

const connectionOptions = Object.assign(
  { basic_auth: { user: process.env.EXISTDB_USER || 'admin', pass: process.env.EXISTDB_PASS || '' } },
  readOptionsFromEnv()
)

const testModulePaths = [
  'xmldb:exist:///db/apps/semver-xq/tests/coerce.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/compare.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/expath-package-semver-template.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/serialize.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/sort.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/validate-and-parse.xqm'
]

const xquery = `
import module namespace test="http://exist-db.org/xquery/xqsuite"
    at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";

test:suite((
    ${testModulePaths.map(p => `inspect:module-functions(xs:anyURI("${p}"))`).join(',\n    ')}
))
`

async function runTests () {
  console.log('Running XQSuite tests...')

  let result
  try {
    const db = getXmlRpcClient(connectionOptions)
    result = await db.queries.readAll(xquery, {})
  } catch (err) {
    console.error('Failed to run tests:', err.message)
    process.exit(1)
  }

  // Each page is a serialized <testsuite> element; wrap for parsing
  const xml = `<testsuites>${result.pages.join('')}</testsuites>`
  const doc = new DOMParser().parseFromString(xml, 'text/xml')
  const testsuites = doc.getElementsByTagName('testsuite')

  let totalTests = 0
  let totalFailures = 0
  let totalErrors = 0

  for (let i = 0; i < testsuites.length; i++) {
    const suite = testsuites.item(i)
    const firstTestcase = suite.getElementsByTagName('testcase').item(0)
    const classname = firstTestcase?.getAttribute('classname') || ''
    const name = suite.getAttribute('name') ||
      suite.getAttribute('package') ||
      classname.split(/[/#]/).filter(Boolean).pop() ||
      'unknown'
    const tests = parseInt(suite.getAttribute('tests') || '0', 10)
    const failures = parseInt(suite.getAttribute('failures') || '0', 10)
    const errors = parseInt(suite.getAttribute('errors') || '0', 10)

    totalTests += tests
    totalFailures += failures
    totalErrors += errors

    const status = (failures + errors) === 0 ? 'PASS' : 'FAIL'
    console.log(`  [${status}] ${name}: ${tests} tests, ${failures} failures, ${errors} errors`)
  }

  console.log(`\nTotal: ${totalTests} tests, ${totalFailures} failures, ${totalErrors} errors`)

  if (totalFailures + totalErrors > 0) {
    console.error('\nTests FAILED')
    process.exit(1)
  }

  if (totalTests === 0) {
    console.error('\nNo tests found — check that test modules were uploaded correctly')
    process.exit(1)
  }

  console.log('\nAll tests passed!')
}

runTests()
