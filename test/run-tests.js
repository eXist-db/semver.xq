import axios from 'axios'
import https from 'https'

const server = process.env.EXISTDB_SERVER || 'https://localhost:8443'
const user = process.env.EXISTDB_USER || 'admin'
const pass = process.env.EXISTDB_PASS || ''

// Allow self-signed certs on localhost (eXist-db Docker uses one by default)
const httpsAgent = new https.Agent({ rejectUnauthorized: false })

const testModulePaths = [
  'xmldb:exist:///db/apps/semver-xq/tests/coerce.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/compare.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/expath-package-semver-template.xqm',
  'xmldb:exist:///db/apps/semver-xq/tests/increment.xqm',
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

// Use eXist-db's XML query document format for reliable POST
const requestBody = `<?xml version="1.0" encoding="UTF-8"?>
<query xmlns="http://exist.sourceforge.net/NS/exist">
    <text><![CDATA[${xquery}]]></text>
    <properties>
        <property name="indent" value="no"/>
    </properties>
</query>`

async function runTests () {
  console.log('Running XQSuite tests...')

  let response
  try {
    response = await axios.post(
      `${server}/exist/rest/db`,
      requestBody,
      {
        auth: { username: user, password: pass },
        headers: { 'Content-Type': 'application/xml' },
        httpsAgent
      }
    )
  } catch (err) {
    const status = err.response ? err.response.status : 'no response'
    const data = err.response ? JSON.stringify(err.response.data).slice(0, 500) : ''
    console.error(`Failed to run tests (HTTP ${status}): ${err.message}`, data)
    process.exit(1)
  }

  const xml = response.data
  let totalTests = 0
  let totalFailures = 0
  let totalErrors = 0

  // Parse testsuite elements for failures and errors
  const testsuiteRegex = /<testsuite[^>]*>/g
  let match
  while ((match = testsuiteRegex.exec(xml)) !== null) {
    const el = match[0]
    const nameMatch = el.match(/package="([^"]*)"/)
    const testsMatch = el.match(/tests="(\d+)"/)
    const failuresMatch = el.match(/failures="(\d+)"/)
    const errorsMatch = el.match(/errors="(\d+)"/)

    const name = nameMatch ? nameMatch[1] : 'unknown'
    const tests = testsMatch ? parseInt(testsMatch[1], 10) : 0
    const failures = failuresMatch ? parseInt(failuresMatch[1], 10) : 0
    const errors = errorsMatch ? parseInt(errorsMatch[1], 10) : 0

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
