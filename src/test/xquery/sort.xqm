xquery version "3.0";

module namespace sts = "http://http://exist-db.org/xquery/semver-xq/test/sort";

import module namespace semver = "http://exist-db.org/xquery/semver-xq";
declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
	%test:assertEquals(
	    "1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-alpha.beta",
	    "1.0.0-beta", "1.0.0-beta.2", "1.0.0-beta.11",
	    "1.0.0-rc.1", "1.0.0", "2.0.0", "2.1.0", "2.1.1")
function sts:order() {
	let $versions :=
	(
        "1.0.0", "2.0.0", "2.1.0", "2.1.1", "1.0.0-alpha", "1.0.0-alpha.1",
		"1.0.0-alpha.beta", "1.0.0-beta", "1.0.0-beta.11", "1.0.0-beta.2", "1.0.0-rc.1"
    ) return
        semver:sort($versions)
};
