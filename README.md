# semver.xq

[![CI](https://github.com/eXist-db/semver.xq/workflows/CI/badge.svg)](https://github.com/eXist-db/semver.xq/actions?query=workflow%3ACI)
[![License](https://img.shields.io/badge/license-BSD%203%20Clause-blue.svg)](http://opensource.org/licenses/BSD-3-Clause)

Validate, compare, sort, parse, and serialize Semantic Versioning (SemVer) 2.0.0 version strings, using XQuery.

SemVer rules are applied strictly, raising errors when version strings do not conform to the spec. 

## Building
* Requirements: Java 8, Apache Maven 3.3+, Git.

If you want to create an EXPath Package for the app, you can run:

```bash
$ mvn package
```

There will be a `.xar` file in the `target/` sub-folder.
