//
//  IPTests.swift
//  CIDR
//
//  Copyright 2016 TIEN-CHE TSAI
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import CIDR

class IPCreationTests: XCTestCase {

    func testIPv4() {
        let googleDNS2 = IPv4Address(groups: [8, 8, 8, 8])!
        XCTAssertEqual(String(googleDNS2), "8.8.8.8")

        let localhost = IPv4Address(groups: 127, 0, 0, 1)!
        XCTAssertEqual(String(localhost), "127.0.0.1")
    }

    func testStringLiterals() {
        let googleDNSIPv4 = "8.8.4.4" as IPv4Address
        XCTAssertEqual(String(googleDNSIPv4), "8.8.4.4")
        XCTAssertEqual(Array(googleDNSIPv4.groups), [8, 8, 4, 4])
    }

    func testArrayLiterals() {
        let googleDNSIPv4 = [8, 8, 4, 4] as IPv4Address
        XCTAssertEqual(String(googleDNSIPv4), "8.8.4.4")
        XCTAssertEqual(Array(googleDNSIPv4.groups), [8, 8, 4, 4])
    }

    func testDescription() {
        let googleDNSIPv4 = IPv4Address(groups: 8, 8, 4, 4)!
        XCTAssertEqual(String(googleDNSIPv4), "8.8.4.4")
    }

}
