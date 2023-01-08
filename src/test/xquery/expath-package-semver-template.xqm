(:
 : Copyright © 2022, Joe Wicentowski
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

module namespace epst = "http://exist-db.org/xquery/semver/test/expath-package-semver-template";

import module namespace semver = "http://exist-db.org/xquery/semver";

declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
    %test:assertTrue
function epst:validate-major() {
    semver:validate-expath-package-semver-template("2")
};

declare
    %test:assertTrue
function epst:validate-minor() {
    semver:validate-expath-package-semver-template("2.3")
};

declare
    %test:assertFalse
function epst:validate-patch() {
    semver:validate-expath-package-semver-template("2.3.4")
};

declare
    %test:assertFalse
function epst:validate-patch-zerp() {
    semver:validate-expath-package-semver-template("2.3.0")
};

declare
    %test:assertEquals("2.0.0")
function epst:major-min() {
    semver:resolve-expath-package-semver-template-min("2")
    => semver:serialize-parsed()
};

declare
    %test:assertEquals("3.0.0")
function epst:major-max() {
    semver:resolve-expath-package-semver-template-max("2")
    => semver:serialize-parsed()
};

declare
    %test:assertEquals("2.1.0")
function epst:minor-min() {
    semver:resolve-expath-package-semver-template-min("2.1")
    => semver:serialize-parsed()
};

declare
    %test:assertEquals("2.2.0")
function epst:minor-max() {
    semver:resolve-expath-package-semver-template-max("2.1")
    => semver:serialize-parsed()
};

declare
    %test:assertEquals("4.2.0", "4.7.1")
function epst:public-repo-style-scenario() {
    let $semver-min := "4.1.0"
    let $semver-max := "4" 
    let $available-versions := ("5.0.0", "5.0.0-SNAP", "4.1.0-SNAPSHOT", "6.0.1", "4.7.1", "3.3.0", "4.2.0")
    let $semver-min-resolved := semver:resolve-if-expath-package-server-template-else-parse($semver-min, "min", true())
    let $semver-max-resolved := semver:resolve-if-expath-package-server-template-else-parse($semver-max, "max", true())
    let $available-versions-parsed-sorted := ($available-versions ! semver:parse(., true())) => semver:sort-parsed()
    for $version in $available-versions-parsed-sorted
    where semver:ge-parsed($version, $semver-min-resolved) and semver:lt-parsed($version, $semver-max-resolved)
    return
        semver:serialize-parsed($version)
};
