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

module namespace stse = "http://exist-db.org/xquery/semver/test/serialize";

import module namespace semver = "http://exist-db.org/xquery/semver";

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
