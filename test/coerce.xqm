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

module namespace stco = "http://exist-db.org/xquery/semver/test/coerce";

import module namespace semver = "http://exist-db.org/xquery/semver";

declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
    %test:assertEquals
    (
        '<semver major="0" minor="0" patch="0"/>',
        '<semver major="1" minor="0" patch="0"/>',
        '<semver major="4" minor="0" patch="0"/>',
        '<semver major="99999" minor="0" patch="0"/>'
    )
function stco:major() {
    (
        "0",
        "1",
        "4",
        "99999"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="0" minor="1" patch="0"/>',
        '<semver major="0" minor="4" patch="0"/>',
        '<semver major="1" minor="0" patch="0"/>',
        '<semver major="1" minor="1" patch="0"/>',
        '<semver major="1" minor="4" patch="0"/>'
    )
function stco:major-minor() {
    (
        "0.1",
        "0.4",
        "1.0",
        "1.1",
        "1.4"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="0" minor="0" patch="0"><pre-release>RC1</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>SNAPSHOT</pre-release></semver>',
        '<semver major="4" minor="0" patch="0"><pre-release>alpha-beta</pre-release></semver>'
    )
function stco:major-pre-release() {
    (
        "0-RC1",
        "1-SNAPSHOT",
        "4-alpha-beta"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="0" minor="1" patch="0"><pre-release>SNAPSHOT</pre-release></semver>',
        '<semver major="0" minor="4" patch="0"><pre-release>RC9</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release><pre-release>beta</pre-release></semver>'
    )
function stco:major-minor-pre-release() {
    (
        "0.1-SNAPSHOT",
        "0.4-RC9",
        "1.0-alpha",
        "1.0-alpha.beta"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="0" minor="0" patch="0"><build-metadata>2019</build-metadata></semver>',
        '<semver major="1" minor="0" patch="0"><build-metadata>2019-08-09</build-metadata><build-metadata>2350</build-metadata></semver>'
    )
function stco:major-build-metadata() {
    (
        "0+2019",
        "1+2019-08-09.2350"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="0" minor="1" patch="1"/>',
        '<semver major="10" minor="4" patch="12"/>'
    )
function stco:major-minor-patch() {
    (
        "0.1.1",
        "10.4.012"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="0" minor="1" patch="1"><pre-release>SNAPSHOT</pre-release></semver>',
        '<semver major="10" minor="4" patch="12"><pre-release>alpha-beta</pre-release></semver>',
        '<semver major="10" minor="4" patch="12"><pre-release>alpha</pre-release><pre-release>gamma</pre-release></semver>'
    )
function stco:major-minor-patch-pre-release() {
    (
        "0.1.1-SNAPSHOT",
        "10.4.012-alpha-beta",
        "10.4.012-alpha.gamma"
    ) ! stco:semver-to-xml(semver:coerce(.))
};

declare
    %test:assertEquals
    (
        '<semver major="1" minor="2" patch="3"><pre-release>stuff</pre-release><pre-release>AND</pre-release><build-metadata>things-yeah</build-metadata><build-metadata>YES</build-metadata></semver>'
    )
function stco:major-minor-patch-pre-release-build-metadata() {
    (
        "1.2.3-stuff.AND+things-yeah.YES"
    ) ! stco:semver-to-xml(semver:coerce(.))
};


declare
    %private
function stco:semver-to-xml($semver) {
    <semver major="{$semver?major}" minor="{$semver?minor}" patch="{$semver?patch}">{
        array:for-each($semver?pre-release, function($i) { <pre-release>{$i}</pre-release> }),
        array:for-each($semver?build-metadata, function($i) { <build-metadata>{$i}</build-metadata> })
    }</semver>
};
