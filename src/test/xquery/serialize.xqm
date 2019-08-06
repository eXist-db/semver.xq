xquery version "3.1";

module namespace stse = "http://http://exist-db.org/xquery/semver-xq/test/serialize";

import module namespace semver = "http://exist-db.org/xquery/semver-xq";
declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
	%test:assertEquals("5.0.0-RC.5+201908061711")
function stse:serialize() {
    semver:serialize(
        5,
        0,
        0,
        ("RC", 5),
        xs:dateTime("2019-08-06T18:11:00+01:00") =>
            adjust-dateTime-to-timezone(xs:dayTimeDuration("PT0H")) =>
            format-dateTime("[Y0001][M01][D01][H01][m01]")
    )
};
