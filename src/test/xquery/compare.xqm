xquery version "3.0";

module namespace stc = "http://http://exist-db.org/xquery/semver-xq/test/compare";

import module namespace semver = "http://exist-db.org/xquery/semver-xq";
declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
	%test:assertEquals("true")
function stc:lt-major() {
	semver:lt("1.0.0", "2.0.0")
};

declare
	%test:assertEquals("true")
function stc:lt-minor() {
	semver:lt("2.0.0", "2.1.0")
};

declare
	%test:assertEquals("true")
function stc:lt-patch() {
	semver:lt("2.1.0", "2.1.1")
};

declare
	%test:assertEquals("true")
function stc:lt-pre-release() {
	semver:lt("1.0.0-alpha", "1.0.0-alpha.1")
};

declare
	%test:assertEquals("true", "true", "true", "true", "true")
function stc:lt-pre-release-dot() {
    semver:lt("1.0.0-alpha.1", "1.0.0-alpha.beta"),
    semver:lt("1.0.0-beta", "1.0.0-beta.2"),
    semver:lt("1.0.0-beta.2", "1.0.0-beta.11"),
    semver:lt("1.0.0-beta.11", "1.0.0-rc.1"),
    semver:lt("1.0.0-rc.1", "1.0.0")
};

declare
	%test:assertEquals("false")
function stc:gt() {
	semver:lt("2.0.0", "1.0.0")
};
