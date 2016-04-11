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

//:
//: # CIDR Playround
//:
//: A simple demo for this lib and also a talk in 4/12 Swift Meetup Taipei
//:

import CIDR

//: ## Use literals to create objects

let googleDNS1 = IPv4Address(groups: 8, 8, 4, 4)!
let googleDNS2: IPv4Address = "8.8.8.8"
let ipAddress = [127, 0, 0, 5] as IPv4Address

let cidr = CIDRv4(ipAddress: ipAddress, prefix: 30)!
let privateNetworkCIDR = "192.168.0.0/16" as CIDRv4

//: ## Showing the CIDR struct

privateNetworkCIDR.count
String(privateNetworkCIDR.netmask)

for ipAddress in cidr {
    String(ipAddress)
}

//:
//: ## The power of **Type Inference** and `StringLiteralsConvertible` Prototol
//:
//: The `contains` is declared by `SequenceType` protocol which accepts an argument of its Element type.
//: In the declaration of `CIDRv4` structure says its Element type is `IPv4Address`. By the way, The `IPv4Address`
//: conforms to `StringLiteralsConvertible`.
//:
//: So here, the **Type Inference** knows this method accepts only `IPv4Address` and then converts the `String`
//: argument into an instance of `IPv4Address`.
//:

cidr.contains("127.0.0.1")
privateNetworkCIDR.contains("127.0.0.6")
privateNetworkCIDR.contains("192.168.0.1")
