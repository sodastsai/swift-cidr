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

import CIDR

let ipAddress = [127, 0, 0, 5] as IPv4Address

let cidr = CIDRv4(ipAddress: ipAddress, prefix: 31)!
cidr.count
for ipAddress in cidr {
    String(ipAddress)
}
cidr.contains(ipAddress)
cidr.netmask
