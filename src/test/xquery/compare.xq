xquery version "3.1";

import module namespace semver = "http://joewiz.org/ns/xquery/semver" at "semver.xqm";

(: Test sets taken from examples in https://semver.org/ :)

let $version-sets :=
    (
        ["1.0.0", "2.0.0"],
        ["2.0.0", "2.1.0"],
        ["2.1.0", "2.1.1"],
        ["1.0.0-alpha", "1.0.0-alpha.1"],
        ["1.0.0-alpha.1", "1.0.0-alpha.beta"],
        ["1.0.0-alpha.beta", "1.0.0-beta"],
        ["1.0.0-beta", "1.0.0-beta.2"],
        ["1.0.0-beta.2", "1.0.0-beta.11"],
        ["1.0.0-beta.11", "1.0.0-rc.1"],
        ["1.0.0-rc.1", "1.0.0"]
    )
let $results :=
    for $set in $version-sets
    return
        map { "set": $set, "lt": semver:lt($set?1, $set?2) }
return
    array { $results }