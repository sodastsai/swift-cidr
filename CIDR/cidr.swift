//
//  cidr.swift
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

public protocol CIDR: CollectionType, CustomStringConvertible, StringLiteralConvertible {
    associatedtype Element: IPAddress

    var ipAddress: Element { get }
    var prefix: Index { get }
    var startIPAddress: Element { get }
    var netmask: Element { get }

    init?(ipAddress: Element, prefix: Index)
    init?(string: String)
}

// MARK: - Common Implementations

extension CIDR where Self.Index == Int {
    public init?(string: String) {
        let cidrStringComps = string.componentsSeparatedByString("/")
        guard cidrStringComps.count == 2 else {
            return nil
        }
        guard let ipAddress = Element(groups: cidrStringComps[0]) else {
            return nil
        }
        guard let prefix = Int(cidrStringComps[1]) else {
            return nil
        }
        self.init(ipAddress: ipAddress, prefix: prefix)
    }
}

extension CIDR where Self.Index == Int {
    public var startIPAddress: Element {
        let freeOffset = Element.bitsSize - self.prefix
        let bitmask = (Element.Value.max >> freeOffset) << freeOffset
        return Element(value: self.ipAddress.value & bitmask)
    }

    public var netmask: Element {
        let freeOffset = Element.bitsSize - self.prefix
        let bitmask = (Element.Value.max >> freeOffset) << freeOffset
        return Element(value: bitmask)
    }
}

// MARK: - CollectionType protocol

extension CIDR where Self.Index == Int {

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return pow(2, exp: (Element.bitsSize - self.prefix))
    }

    public subscript(position: Int) -> Element {
        return self.startIPAddress + position
    }
}

// MARK: - String Literals

extension CIDR {
    public var description: String {
        return "\(self.ipAddress)/\(self.prefix)"
    }
}

extension CIDR where Self.Index == Int {
    public init(stringLiteral value: String) {
        self = Self(string: value) ?? Self(ipAddress: Element(value: 0), prefix: 0)!
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

// MARK: - Concrete Structures

public struct CIDRv4: CIDR {
    public let ipAddress: IPv4Address
    public let prefix: Int

    public init?(ipAddress: IPv4Address, prefix: Int) {
        guard prefix <= IPv4Address.bitsSize else {
            return nil
        }
        self.ipAddress = ipAddress
        self.prefix = prefix
    }
}
