xquery version "3.1";

import module namespace semver = "http://joewiz.org/ns/xquery/semver" at "semver.xqm";

semver:serialize(
    5,
    0,
    0,
    ("RC", 5),
    current-dateTime() =>
        adjust-dateTime-to-timezone(xs:dayTimeDuration("PT0H")) =>
        format-dateTime("[Y0001][M01][D01][H01][m01]")
)