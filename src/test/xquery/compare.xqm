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

module namespace stc = "http://exist-db.org/xquery/semver/test/compare";

import module namespace semver = "http://exist-db.org/xquery/semver";

declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
    %test:assertEquals("true")
function stc:lt-major() {
    semver:lt("1.0.0", "2.0.0")
};

declare
    %test:assertEquals("true")
function stc:lt-major-parsed() {
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}, 
        map{"major":2,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("true")
function stc:lt-minor() {
    semver:lt("2.0.0", "2.1.0")
};

declare
    %test:assertEquals("true")
function stc:lt-minor-parsed() {
    semver:lt-parsed(
        map{"major":2,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}, 
        map{"major":2,"minor":1,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,1,0,[],[]]}
    )
};

declare
    %test:assertEquals("true")
function stc:lt-patch() {
    semver:lt("2.1.0", "2.1.1")
};

declare
    %test:assertEquals("true")
function stc:lt-patch-parsed() {
    semver:lt-parsed(
        map{"major":2,"minor":1,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}, 
        map{"major":2,"minor":1,"patch":1,"pre-release":[],"build-metadata":[],"identifiers":[2,1,1,[],[]]}
    )
};

declare
    %test:assertEquals("true")
function stc:lt-pre-release() {
    semver:lt("1.0.0-alpha", "1.0.0-alpha.1")
};

declare
    %test:assertEquals("true")
function stc:lt-pre-release-parsed() {
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":["alpha"],"build-metadata":[],"identifiers":[2,0,0,["alpha"],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":["alpha",1],"build-metadata":[],"identifiers":[2,1,1,["alpha",1],[]]}
    )
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
    %test:assertEquals("true", "true", "true", "true", "true")
function stc:lt-pre-release-dot-parsed() {
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":["alpha",1],"build-metadata":[],"identifiers":[1,0,0,["alpha",1],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":["alpha","beta"],"build-metadata":[],"identifiers":[1,0,0,["alpha","beta"],[]]}
    ),
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":["beta"],"build-metadata":[],"identifiers":[1,0,0,["alpha"],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":["beta",2],"build-metadata":[],"identifiers":[1,0,0,["beta",2],[]]}
    ),
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":["beta",1],"build-metadata":[],"identifiers":[1,0,0,["alpha"],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":["beta",11],"build-metadata":[],"identifiers":[1,0,0,["beta",11],[]]}
    ),
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":["beta",11],"build-metadata":[],"identifiers":[1,0,0,["alpha"],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":["rc",1],"build-metadata":[],"identifiers":[1,0,0,["rc",1],[]]}
    ),
    semver:lt-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":["rc",1],"build-metadata":[],"identifiers":[1,0,0,["rc",1],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("true")
function stc:gt() {
    semver:gt("2.0.0", "1.0.0")
};

declare
    %test:assertEquals("true")
function stc:gt-parsed() {
    semver:gt-parsed(
        map{"major":2,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("true")
function stc:eq() {
    semver:eq("1.0.0", "1.0.0")
};

declare
    %test:assertEquals("true")
function stc:eq-parsed() {
    semver:eq-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("true")
function stc:ne() {
    semver:ne("1.0.0", "2.0.0")
};

declare
    %test:assertEquals("true")
function stc:ne-parsed() {
    semver:ne-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}, 
        map{"major":2,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("0")
function stc:compare-eq() {
    semver:compare("1.0.0", "1.0.0")
};

declare
    %test:assertEquals("0")
function stc:compare-eq-parsed() {
    semver:compare-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("1")
function stc:compare-gt() {
    semver:compare("2.0.0", "1.0.0")
};

declare
    %test:assertEquals("1")
function stc:compare-gt-parsed() {
    semver:compare-parsed(
        map{"major":2,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}, 
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}
    )
};

declare
    %test:assertEquals("-1")
function stc:compare-lt() {
    semver:compare("1.0.0", "2.0.0")
};

declare
    %test:assertEquals("-1")
function stc:compare-lt-parsed() {
    semver:compare-parsed(
        map{"major":1,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[1,0,0,[],[]]}, 
        map{"major":2,"minor":0,"patch":0,"pre-release":[],"build-metadata":[],"identifiers":[2,0,0,[],[]]}
    )
};
