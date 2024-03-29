(:
 : Copyright © 2019, Joe Wicentowski
 : All rights reserved.
 :
 : Redistribution and use in source and binary forms, with or without
 : modification, are permitted provided that the following conditions are met:
 :     * Redistributions of source code must retain the above copyright
 :       notice, this list of conditions and the following disclaimer.
 :     * Redistributions in binary form must reproduce the above copyright
 :       notice, this list of conditions and the following disclaimer in the
 :       documentation and/or other materials provided with the distribution.
 :     * Neither the name of the <organization> nor the
 :       names of its contributors may be used to endorse or promote products
 :       derived from this software without specific prior written permission.
 :
 : THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 : ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 : WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 : DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 : DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 : (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 : LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 : ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 : (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 : SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 :)
xquery version "3.1";

module namespace sts = "http://exist-db.org/xquery/semver/test/sort";

import module namespace semver = "http://exist-db.org/xquery/semver";

declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
    %test:assertEquals(
        "1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-alpha.beta",
        "1.0.0-beta", "1.0.0-beta.2", "1.0.0-beta.11",
        "1.0.0-rc.1", "1.0.0", "2.0.0", "2.1.0", "2.1.1")
function sts:sort() {
    let $versions :=
    (
        "1.0.0", "2.0.0", "2.1.0", "2.1.1", "1.0.0-alpha", "1.0.0-alpha.1",
        "1.0.0-alpha.beta", "1.0.0-beta", "1.0.0-beta.11", "1.0.0-beta.2", "1.0.0-rc.1"
    ) return
        semver:sort($versions)
};

declare
    %test:assertEquals("1.1.1", "2.2.0", "3.0.0")
function sts:sort-with-coercion() {
    semver:sort(("1.1.1", "2.2", "3"), true())
};

declare
    %test:assertEquals(
        "1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-alpha.beta",
        "1.0.0-beta", "1.0.0-beta.2", "1.0.0-beta.11",
        "1.0.0-rc.1", "1.0.0", "1.1.1", "2.0.0", "2.1.0",
        "2.1.1", "2.2", "3")
function sts:sort-items-with-coercion() {
    let $packages :=
        <packages>
            <package version="1.0.0"/>
            <package version="1.1.1"/>
            <package version="2.0.0"/>
            <package version="2.1.0"/>
            <package version="2.1.1"/>
            <package version="2.2"/>
            <package version="3"/>
            <package version="1.0.0-alpha"/>
            <package version="1.0.0-alpha.1"/>
            <package version="1.0.0-alpha.beta"/>
            <package version="1.0.0-beta"/>
            <package version="1.0.0-beta.11"/>
            <package version="1.0.0-beta.2"/>
            <package version="1.0.0-rc.1"/>
        </packages>
    return
        semver:sort($packages/package, function($item) { $item/@version }, true()) ! 
            ./@version/string()
};
