# semver.xq

[![CI](https://github.com/eXist-db/semver.xq/workflows/CI%20semver.xq/badge.svg)](https://github.com/eXist-db/semver.xq/actions?query=workflow%3A%22CI+semver.xq%22)
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

## Performing a Release

This project is configured to use the [Maven Release Plugin](https://maven.apache.org/maven-release/maven-release-plugin/)
to make creating and subsequently publishing a release easy.

The release plugin will take care of:
1. Testing the project (all tests must pass)
2. Verifying all rules, e.g. license declarations present, etc.
3. Creating a Git Tag and pushing the Tag to GitHub
4. Building and signing the artifacts (e.g. EXPath Pkg `.xar` file).

Before performing the release, in addition to the Build requirements you need an installed and functioning copy of GPG or [GnuPG](https://gnupg.org/) with your private key setup correctly for signing.

To perform the release, from within your local Git cloned repository run:

```bash
mvn release:prepare && mvn release:perform
```

You will be prompted for the answers to a few questions along the way. The default response will be provided for you, and you can simply press "Enter" (or "Return") to accept it. Alternatively you may enter your own value and press "Enter" (or "Return").
```bash
What is the release version for "semver.xq"? (org.exist-db.xquery:semver-xq) 2.3.1: : 2.4.0
What is SCM release tag or label for "semver.xq"? (org.exist-db.xquery:semver-xq) 2.4.0: :
What is the new development version for "semver.xq"? (org.exist-db.xquery:semver-xq) 2.4.1-SNAPSHOT: :
```

* For the `release version`, please sensibly consider using the next appropriate [SemVer 2.0.0](https://semver.org/) version number.
* For the `SCM release tag`, please use the same value as the `release version`.
* For the `new development version`, the default value should always suffice.

Once the release process completes, there will be a `.xar` file in the `target/` sub-folder. This file may be published to:
1. GitHub Releases - https://github.com/eXist-db/semver.xq/releases
2. The eXist-db Public EXPath Repository - https://exist-db.org/exist/apps/public-repo/admin

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

## API Documentation

* Variables: [$semver:regex](#var_semver_regex), [$semver:coerce-regex](#var_semver_coerce-regex), [$semver:expath-package-semver-template-regex](#var_semver_expath-package-semver-template-regex)
* Functions: [semver:validate\#1](#func_semver_validate_1), [semver:validate-expath-package-semver-template\#1](#func_semver_validate-expath-package-semver-template_1), [semver:parse\#1](#func_semver_parse_1), [semver:parse\#2](#func_semver_parse_2), [semver:coerce\#1](#func_semver_coerce_1), [semver:resolve-expath-package-semver-template-min\#1](#func_semver_resolve-expath-package-semver-template-min_1), [semver:resolve-expath-package-semver-template-max\#1](#func_semver_resolve-expath-package-semver-template-max_1), [semver:resolve-expath-package-semver-template\#2](#func_semver_resolve-expath-package-semver-template_2), [semver:satisfies-expath-package-dependency-versioning-attributes\#5](#func_semver_satisfies-expath-package-dependency-versioning-attributes_5), [semver:serialize\#5](#func_semver_serialize_5), [semver:serialize\#1](#func_semver_serialize_1), [semver:serialize-parsed\#1](#func_semver_serialize-parsed_1), [semver:compare\#2](#func_semver_compare_2), [semver:compare\#3](#func_semver_compare_3), [semver:compare-parsed\#2](#func_semver_compare-parsed_2), [semver:lt\#2](#func_semver_lt_2), [semver:lt\#3](#func_semver_lt_3), [semver:lt-parsed\#2](#func_semver_lt-parsed_2), [semver:le\#2](#func_semver_le_2), [semver:le\#3](#func_semver_le_3), [semver:le-parsed\#2](#func_semver_le-parsed_2), [semver:gt\#2](#func_semver_gt_2), [semver:gt\#3](#func_semver_gt_3), [semver:gt-parsed\#2](#func_semver_gt-parsed_2), [semver:ge\#2](#func_semver_ge_2), [semver:ge\#3](#func_semver_ge_3), [semver:ge-parsed\#2](#func_semver_ge-parsed_2), [semver:eq\#2](#func_semver_eq_2), [semver:eq\#3](#func_semver_eq_3), [semver:eq-parsed\#2](#func_semver_eq-parsed_2), [semver:ne\#2](#func_semver_ne_2), [semver:ne\#3](#func_semver_ne_3), [semver:ne-parsed\#2](#func_semver_ne-parsed_2), [semver:sort\#1](#func_semver_sort_1), [semver:sort\#2](#func_semver_sort_2), [semver:sort\#3](#func_semver_sort_3), [semver:sort-parsed\#1](#func_semver_sort-parsed_1)


### Variables

#### <a name="var_semver_regex"/> $semver:regex
```xquery
$semver:regex as
```
A regular expression for validating SemVer strings and parsing valid SemVer strings

See: https://semver.org/spec/v2.0.0.html#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string


#### <a name="var_semver_coerce-regex"/> $semver:coerce-regex
```xquery
$semver:coerce-regex as
```
A forgiving regular expression for capturing groups needed to coerce a non-SemVer string into SemVer components


#### <a name="var_semver_expath-package-semver-template-regex"/> $semver:expath-package-semver-template-regex
```xquery
$semver:expath-package-semver-template-regex as
```
A regular expression for validating SemVer templates as defined in the EXPath Package spec


### Functions

#### <a name="func_semver_validate_1"/> semver:validate\#1
```xquery
semver:validate($version as xs:string) as xs:boolean
```
Validate whether a SemVer string conforms to the spec

**Params**
* `$version as xs:string` — A version string

**Returns** `xs:boolean`: True if the version is valid, false if not

#### <a name="func_semver_validate-expath-package-semver-template_1"/> semver:validate-expath-package-semver-template\#1
```xquery
semver:validate-expath-package-semver-template($version as xs:string) as xs:boolean
```
Validate whether a version string conforms to the rules for SemVer templates as defined in the EXPath Package spec

**Params**
* `$version as xs:string` — A version string

**Returns** `xs:boolean`: True if the version is a SemVer template, false if not

#### <a name="func_semver_parse_1"/> semver:parse\#1
```xquery
semver:parse($version as xs:string) as map(*)
```
Parse a SemVer string (strictly)

**Params**
* `$version as xs:string` — A version string

**Returns** `map(*)`: A map containing analysis of the parsed version, with entries for each identifier ("major", "minor", "patch", "pre-release", and "build-metadata"), and an "identifiers" entry with all identifiers in an array.

**Errors** `regex-error`, `identifier-error`

#### <a name="func_semver_parse_2"/> semver:parse\#2
```xquery
semver:parse($version as xs:string, $coerce as xs:boolean) as map(*)
```
Parse a SemVer string (with an option to coerce invalid SemVer strings)

**Params**
* `$version as xs:string` — A version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `map(*)`: A map containing analysis of the parsed SemVer versions, with entries for each identifier ("major", "minor", "patch", "pre-release", and "build-metadata"), and an "identifiers" entry with all identifiers in an array.

**Errors** `regex-error`, `identifier-error`

#### <a name="func_semver_coerce_1"/> semver:coerce\#1
```xquery
semver:coerce($version as xs:string) as map(*)
```
Coerce a non-SemVer version string into a SemVer string and parse it as such

**Params**
* `$version as xs:string` — A version string which will be coerced into a parsed SemVer version

**Returns** `map(*)`: A map containing analysis of the coerced version, with entries for each identifier ("major", "minor", "patch", "pre-release", and "build-metadata"), and an "identifiers" entry with all identifiers in an array. Fallback for invalid version strings: 0.0.0.

#### <a name="func_semver_resolve-expath-package-semver-template-min_1"/> semver:resolve-expath-package-semver-template-min\#1
```xquery
semver:resolve-expath-package-semver-template-min($version as xs:string) as map(*)
```
Resolve an EXPath Package SemVer Template as minimum (floor)

**Params**
* `$version as xs:string` — An EXPath SemVer Template

**Returns** `map(*)`: A map containing the resolved version, with entries for each identifier ("major", "minor", "patch", "pre-release", and "build-metadata"), and an "identifiers" entry with all identifiers in an array.

#### <a name="func_semver_resolve-expath-package-semver-template-max_1"/> semver:resolve-expath-package-semver-template-max\#1
```xquery
semver:resolve-expath-package-semver-template-max($version as xs:string) as map(*)
```
Resolve an EXPath Package SemVer Template as maximum (ceiling)

**Params**
* `$version as xs:string` — An EXPath SemVer Template

**Returns** `map(*)`: A map containing the resolved version, with entries for each identifier ("major", "minor", "patch", "pre-release", and "build-metadata"), and an "identifiers" entry with all identifiers in an array.

#### <a name="func_semver_resolve-expath-package-semver-template_2"/> semver:resolve-expath-package-semver-template\#2
```xquery
semver:resolve-expath-package-semver-template($version as xs:string, $mode as xs:string)
```
Resolve an EXPath SemVer Package Template

**Params**
* `$version as xs:string` — An EXPath Package SemVer Template
* `$mode as xs:string` — Mode for resolving the template: "min" (floor) or "max" (ceiling)

#### <a name="func_semver_satisfies-expath-package-dependency-versioning-attributes_5"/> semver:satisfies-expath-package-dependency-versioning-attributes\#5
```xquery
semver:satisfies-expath-package-dependency-versioning-attributes(
    $version as xs:string,
    $versions as xs:string?,
    $semver as xs:string?,
    $semver-min as xs:string?,
    $semver-max as xs:string?
) as xs:boolean
```
Check if a version satisfies EXPath Package dependency versioning attributes.

**Params**
* `$version as xs:string` — A version string
* `$versions as xs:string?` — An EXPath Package "versions" versioning attribute
* `$semver as xs:string?` — An EXPath Package "semver" versioning attribute
* `$semver-min as xs:string?` — An EXPath Package "semver-min" versioning attribute
* `$semver-max as xs:string?` — An EXPath Package "semver-max" versioning attribute

**Returns** `xs:boolean`: True if the version satisfies the attributes, or false if not

#### <a name="func_semver_serialize_5"/> semver:serialize\#5
```xquery
semver:serialize(
    $major as xs:integer,
    $minor as xs:integer,
    $patch as xs:integer,
    $pre-release as xs:anyAtomicType*,
    $build-metadata as xs:anyAtomicType*
)
```
Serialize a SemVer string

**Params**
* `$major as xs:integer` — The major version
* `$minor as xs:integer` — The minor version
* `$patch as xs:integer` — The patch version
* `$pre-release as xs:anyAtomicType*` — Pre-release identifiers
* `$build-metadata as xs:anyAtomicType*` — Build identifiers

#### <a name="func_semver_serialize_1"/> semver:serialize\#1
```xquery
semver:serialize($parsed-version as map(*))
```
Serialize a parsed SemVer version _(deprecated as of 2.4.0; use `semver:serialize-parsed#1`)_

**Params**
* `$parsed-version as map(*)` — A map containing the components of the SemVer string

#### <a name="func_semver_serialize-parsed_1"/> semver:serialize-parsed\#1
```xquery
semver:serialize-parsed($parsed-version as map(*))
```
Serialize a parsed SemVer version

**Params**
* `$parsed-version as map(*)` — A map containing the components of the SemVer string

#### <a name="func_semver_compare_2"/> semver:compare\#2
```xquery
semver:compare($v1 as xs:string, $v2 as xs:string) as xs:integer
```
Compare two SemVer strings (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:integer`

#### <a name="func_semver_compare_3"/> semver:compare\#3
```xquery
semver:compare($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:integer
```
Compare two SemVer strings (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:integer`

#### <a name="func_semver_compare-parsed_2"/> semver:compare-parsed\#2
```xquery
semver:compare-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:integer
```
Compare two parsed SemVer versions

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:integer`

#### <a name="func_semver_lt_2"/> semver:lt\#2
```xquery
semver:lt($v1 as xs:string, $v2 as xs:string) as xs:boolean
```
Test if v1 is a lower version than v2 (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:boolean`: true if v1 is less than v2

#### <a name="func_semver_lt_3"/> semver:lt\#3
```xquery
semver:lt($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:boolean
```
Test if v1 is a lower version than v2 (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:boolean`: true if v1 is less than v2

#### <a name="func_semver_lt-parsed_2"/> semver:lt-parsed\#2
```xquery
semver:lt-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:boolean
```
Test if a parsed v1 is a lower version than a parsed v2

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:boolean`: true if v1 is less than v2

#### <a name="func_semver_le_2"/> semver:le\#2
```xquery
semver:le($v1 as xs:string, $v2 as xs:string) as xs:boolean
```
Test if v1 is a lower version or the same version as v2 (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:boolean`: true if v1 is less than or equal to v2

#### <a name="func_semver_le_3"/> semver:le\#3
```xquery
semver:le($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:boolean
```
Test if v1 is a lower version or the same version as v2 (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:boolean`: true if v1 is less than or equal to v2

#### <a name="func_semver_le-parsed_2"/> semver:le-parsed\#2
```xquery
semver:le-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:boolean
```
Test if a parsed v1 is a lower version or the same version as a parsed v2

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:boolean`: true if v1 is less than or equal to v2

#### <a name="func_semver_gt_2"/> semver:gt\#2
```xquery
semver:gt($v1 as xs:string, $v2 as xs:string) as xs:boolean
```
Test if v1 is a higher version than v2 (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:boolean`: true if v1 is greater than v2

#### <a name="func_semver_gt_3"/> semver:gt\#3
```xquery
semver:gt($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:boolean
```
Test if v1 is a higher version than v2 (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:boolean`: true if v1 is greater than v2

#### <a name="func_semver_gt-parsed_2"/> semver:gt-parsed\#2
```xquery
semver:gt-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:boolean
```
Test if a parsed v1 is a higher version than a parsed v2

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:boolean`: true if v1 is greater than v2

#### <a name="func_semver_ge_2"/> semver:ge\#2
```xquery
semver:ge($v1 as xs:string, $v2 as xs:string) as xs:boolean
```
Test if v1 is the same or higher version than v2 (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:boolean`: true if v1 is greater than or equal to v2

#### <a name="func_semver_ge_3"/> semver:ge\#3
```xquery
semver:ge($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:boolean
```
Test if v1 is the same or higher version than v2 (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:boolean`: true if v1 is greater than or equal to v2

#### <a name="func_semver_ge-parsed_2"/> semver:ge-parsed\#2
```xquery
semver:ge-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:boolean
```
Test if a parsed v1 is the same or higher version than a parsed v2

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:boolean`: true if v1 is greater than or equal to v2

#### <a name="func_semver_eq_2"/> semver:eq\#2
```xquery
semver:eq($v1 as xs:string, $v2 as xs:string) as xs:boolean
```
Test if v1 is equal to v2 (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:boolean`: true if v1 is equal to v2

#### <a name="func_semver_eq_3"/> semver:eq\#3
```xquery
semver:eq($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:boolean
```
Test if v1 is equal to v2 (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:boolean`: true if v1 is equal to v2

#### <a name="func_semver_eq-parsed_2"/> semver:eq-parsed\#2
```xquery
semver:eq-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:boolean
```
Test if a parsed v1 is equal to a parsed v2

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:boolean`: true if v1 is equal to v2

#### <a name="func_semver_ne_2"/> semver:ne\#2
```xquery
semver:ne($v1 as xs:string, $v2 as xs:string) as xs:boolean
```
Test if v1 is not equal to v2 (strictly)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string

**Returns** `xs:boolean`: true if v1 is not equal to v2

#### <a name="func_semver_ne_3"/> semver:ne\#3
```xquery
semver:ne($v1 as xs:string, $v2 as xs:string, $coerce as xs:boolean) as xs:boolean
```
Test if v1 is not equal to v2 (with an option to coerce invalid SemVer strings)

**Params**
* `$v1 as xs:string` — A version string
* `$v2 as xs:string` — A second version string
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:boolean`: true if v1 is not equal to v2

#### <a name="func_semver_ne-parsed_2"/> semver:ne-parsed\#2
```xquery
semver:ne-parsed($parsed-v1 as map(*), $parsed-v2 as map(*)) as xs:boolean
```
Test if a parsed v1 is not equal to a parsed v2

**Params**
* `$parsed-v1 as map(*)` — A parsed SemVer version
* `$parsed-v2 as map(*)` — A second parsed SemVer version

**Returns** `xs:boolean`: true if v1 is not equal to v2

#### <a name="func_semver_sort_1"/> semver:sort\#1
```xquery
semver:sort($versions as xs:string+) as xs:string+
```
Sort SemVer strings (strictly)

**Params**
* `$versions as xs:string+` — A sequence of version strings

**Returns** `xs:string+`: A sequence of sorted version strings

#### <a name="func_semver_sort_2"/> semver:sort\#2
```xquery
semver:sort($versions as xs:string*, $coerce as xs:boolean) as xs:string*
```
Sort SemVer strings (with an option to coerce invalid SemVer strings)

**Params**
* `$versions as xs:string*` — A sequence of version strings
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `xs:string*`: A sequence of sorted version strings

#### <a name="func_semver_sort_3"/> semver:sort\#3
```xquery
semver:sort($items as item()*, $function as function(*), $coerce as xs:boolean) as item()*
```
Sort arbitrary items by their SemVer strings (with an option to coerce invalid SemVer strings)

**Params**
* `$items as item()*` — A sequence of items to sort
* `$function as function(*)` — A function taking a single parameter used to derive a SemVer string from the item
* `$coerce as xs:boolean` — An option for coercing non-SemVer version strings into parsable form

**Returns** `item()*`: The sequence of items in SemVer order

#### <a name="func_semver_sort-parsed_1"/> semver:sort-parsed\#1
```xquery
semver:sort-parsed($parsed-versions as map(*)*) as map(*)*
```
Sort SemVer maps

**Params**
* `$parsed-versions as map(*)*` — A sequence of SemVer maps, containing entries for each identifier ("major", "minor", "patch", "pre-release", and "build-metadata"), and an "identifiers" entry with all identifiers in an array

**Returns** `map(*)*`: A sorted sequence of SemVer maps

*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
