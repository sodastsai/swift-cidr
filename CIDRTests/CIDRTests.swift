//
//  CIDRTests.swift
//  CIDRTests
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

class CIDRCreationTests: XCTestCase {

    func testCreation() {
        let cidr1 = CIDRv4(ipAddress: "8.8.8.8", prefix: 32)!
        XCTAssertEqual(String(cidr1), "8.8.8.8/32")

        let cidr2: CIDRv4 = "8.8.4.4/31"
        XCTAssertEqual(String(cidr2), "8.8.4.4/31")
        XCTAssertEqual(cidr2.count, 2)
    }

    func testCount() {
        XCTAssertEqual(CIDRv4(ipAddress: "8.8.8.8", prefix: 32)!.count, 1)
        XCTAssertEqual(CIDRv4(ipAddress: "8.8.4.4", prefix: 31)!.count, 2)
        XCTAssertEqual(CIDRv4(ipAddress: "8.8.4.4", prefix: 16)!.count, 65536)
    }

}
