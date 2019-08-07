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

module namespace stp = "http://http://exist-db.org/xquery/semver-xq/test/parse";

import module namespace semver = "http://exist-db.org/xquery/semver-xq";
declare namespace test = "http://exist-db.org/xquery/xqsuite";


declare
    %test:assertEquals
    (
        '<semver major="0" minor="0" patch="4"/>',
        '<semver major="1" minor="2" patch="3"/>',
        '<semver major="10" minor="20" patch="30"/>',
        '<semver major="1" minor="0" patch="0"/>',
        '<semver major="2" minor="0" patch="0"/>',
        '<semver major="1" minor="1" patch="7"/>',
        '<semver major="99999999999999999999999" minor="999999999999999999" patch="99999999999999999"/>'
    )
function stp:major-minor-patch() {
    (
        "0.0.4",
        "1.2.3",
        "10.20.30",
        "1.0.0",
        "2.0.0",
        "1.1.7",
        "99999999999999999999999.999999999999999999.99999999999999999"
    ) ! stp:semver-to-xml(semver:parse(.))
};

declare
    %test:assertEquals
    (
        'false',
        'false',
        'false',
        'false',
        'false',
        'false'
    )
function stp:invalid-major-minor-patch() {
    (
        "01.1.1",
        "alpha.beta.1",
        "alpha..",
        "01.1.1",
        "1.01.1",
        "1.1.01"
    ) ! semver:validate(.)
};

declare %test:assertEquals
    (
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false'
    )
function stp:incomplete() {
    (
        "1",
        "1.2",
        "+invalid",
        "-invalid",
        "-invalid+invalid",
        "-invalid.01",
        "alpha",
        "alpha.beta",
        "alpha.1",
        "alpha+beta",
        "alpha_beta",
        "alpha.",
        "beta",
        "-alpha.",
        "1.2",
        "1.2.3.DEV",
        "1.2-SNAPSHOT",
        "1.2-RC-SNAPSHOT",
        "-1.0.3-gamma+b7718",
        "+justmeta"
    ) ! semver:validate(.)
};

declare
    %test:assertEquals
    (
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>beta</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release><pre-release>beta</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release><pre-release>beta</pre-release><pre-release>1</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release><pre-release>1</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha0</pre-release><pre-release>valid</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release><pre-release>0valid</pre-release></semver>',
        '<semver major="1" minor="2" patch="3"><pre-release>beta</pre-release></semver>',
        '<semver major="10" minor="2" patch="3"><pre-release>DEV-SNAPSHOT</pre-release></semver>',
        '<semver major="1" minor="2" patch="3"><pre-release>SNAPSHOT-123</pre-release></semver>',
        '<semver major="2" minor="0" patch="1"><pre-release>alpha</pre-release><pre-release>1227</pre-release></semver>',
        '<semver major="1" minor="2" patch="3"><pre-release>---RC-SNAPSHOT</pre-release><pre-release>12</pre-release><pre-release>9</pre-release><pre-release>1--</pre-release><pre-release>12</pre-release></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>0A</pre-release><pre-release>is</pre-release><pre-release>legal</pre-release></semver>'
    )
function stp:major-minor-patch-pre-release() {
    (
            "1.0.0-alpha",
            "1.0.0-beta",
            "1.0.0-alpha.beta",
            "1.0.0-alpha.beta.1",
            "1.0.0-alpha.1",
            "1.0.0-alpha0.valid",
            "1.0.0-alpha.0valid",
            "1.2.3-beta",
            "10.2.3-DEV-SNAPSHOT",
            "1.2.3-SNAPSHOT-123",
            "2.0.1-alpha.1227",
            "1.2.3----RC-SNAPSHOT.12.9.1--.12",
            "1.0.0-0A.is.legal"

    ) ! stp:semver-to-xml(semver:parse(.))
};

declare
    %test:assertEquals
    (
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false',
        'false'
    )
function stp:invalid-major-minor-patch-pre-release() {
    (
        "1.2.3-0123",
        "1.2.3-0123.0123",
        "1.0.0-alpha_beta",
        "1.0.0-alpha..",
        "1.0.0-alpha..1",
        "1.0.0-alpha...1",
        "1.0.0-alpha....1",
        "1.0.0-alpha.....1",
        "1.0.0-alpha......1",
        "1.0.0-alpha.......1",
        "99999999999999999999999.999999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12"
    ) ! semver:validate(.)
};

declare
    %test:assertEquals
    (
        '<semver major="1" minor="1" patch="2"><pre-release>prerelease</pre-release><build-metadata>meta</build-metadata></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha-a</pre-release><pre-release>b-c-somethinglong</pre-release><build-metadata>build</build-metadata><build-metadata>1-aef</build-metadata><build-metadata>1-its-okay</build-metadata></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>rc</pre-release><pre-release>1</pre-release><build-metadata>build</build-metadata><build-metadata>1</build-metadata></semver>',
        '<semver major="2" minor="0" patch="0"><pre-release>rc</pre-release><pre-release>1</pre-release><build-metadata>build</build-metadata><build-metadata>123</build-metadata></semver>',
        '<semver major="1" minor="0" patch="0"><pre-release>alpha</pre-release><build-metadata>beta</build-metadata></semver>',
        '<semver major="1" minor="2" patch="3"><pre-release>---RC-SNAPSHOT</pre-release><pre-release>12</pre-release><pre-release>9</pre-release><pre-release>1--</pre-release><pre-release>12</pre-release><build-metadata>788</build-metadata></semver>',
        '<semver major="1" minor="2" patch="3"><pre-release>---R-S</pre-release><pre-release>12</pre-release><pre-release>9</pre-release><pre-release>1--</pre-release><pre-release>12</pre-release><build-metadata>meta</build-metadata></semver>'
    )
function stp:major-minor-patch-pre-release-build-metadata() {

    (: TODO(AR) the examples below that are commented out are parsed incorrectly! they detect pre-release data which is actually build-metadata:)

    (
        "1.1.2-prerelease+meta",
        (:"1.1.2+meta",
        "1.1.2+meta-valid", :)
        "1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay",
        "1.0.0-rc.1+build.1",
        "2.0.0-rc.1+build.123",
        (:"2.0.0+build.1848", :)
        "1.0.0-alpha+beta",
        "1.2.3----RC-SNAPSHOT.12.9.1--.12+788",
        "1.2.3----R-S.12.9.1--.12+meta" (:,
        "1.0.0+0.build.1-rc.10000aaa-kk-0.1" :)
    ) ! stp:semver-to-xml(semver:parse(.))
};

declare
    %test:assertEquals
    (
        'false',
        'false',
        'false',
        'false'
    )
function stp:invalid-major-minor-patch-pre-release-build-metadata() {
    (
        "1.1.2+.123",
        "9.8.7+meta+meta",
        "1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788",
        "9.8.7-whatever+meta+meta"
    ) ! semver:validate(.)
};

declare
    %private
function stp:semver-to-xml($semver) {
    <semver major="{$semver?major}" minor="{$semver?minor}" patch="{$semver?patch}">{
        array:for-each($semver?pre-release, function($i) { <pre-release>{$i}</pre-release> }),
        array:for-each($semver?build-metadata, function($i) { <build-metadata>{$i}</build-metadata> })
    }</semver>
};
