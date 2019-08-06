(:
 : Copyright © 2017, Joe Wickentowski
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
