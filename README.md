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


## Development / Manual Testing

Simply run: `mvn -Pdev docker:start` to start a Docker environment of eXist-db on port 9090
with the semver.xq package already deployed.

As the Docker environment binds the files from the host filesystem, changes to the source code
are reflected immediately in the running eXist-db environment.

You can override the Docker host port for eXist-db from port 9090 to a port of your choosing by
specifying `-Ddev.port=9191`, e.g.: `mvn -Pdev -Ddev.port=9191 docker:start`.

If you also want the Dashboard and eXide to be available from the Docker environment of eXist-db
you can invoke the target `public-xar-repo:resolve` before you call `docker:start`,
e.g. `mvn -Pdev public-xar-repo:resolve docker:start`.

To stop the Docker environment run: `mvn -Pdev docker:stop`.
