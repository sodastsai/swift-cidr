//
//  ip.swift
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

public protocol IPAddressValueType: UnsignedIntegerType {
    static var max: Self { get }

    init(_ value: Int)
    var toInt: Int { get }

    func + (lhs: Self, rhs: Int) -> Self
    func << (lhs: Self, rhs: Int) -> Self
    func >> (lhs: Self, rhs: Self) -> Self
    func >> (lhs: Self, rhs: Int) -> Self
}

public protocol IPAddressGroupType: UnsignedIntegerType {
    static var max: Self { get }

    init(_ value: Int)
    var toInt: Int { get }

    init?(_ string: String, radix: Int)
}

public protocol IPAddress: Equatable, Comparable, CustomStringConvertible,
                           ArrayLiteralConvertible, StringLiteralConvertible {

    associatedtype Value: IPAddressValueType
    associatedtype Group: IPAddressGroupType
    var value: Value { get }

    init(value: Value)
    init?(groups: Group...)
    init?(groups: [Group])
    init?(groups: String)

    static var bitsSize: Int { get }
    static func bitsIndices() -> AnyGenerator<Int>

    static var groupRadix: Int { get }
    static var groupSeparator: String { get }
    static var groupsCount: Int { get }
    static var groupBitsSize: Int { get }
    static func groupsIndices() -> AnyGenerator<Int>
    var groups: AnyGenerator<Group> { get }

    func + (lhs: Self, rhs: Int) -> Self
}

extension IPAddress {

    public init?(groups: [Group]) {
        guard groups.count == Self.groupsCount else {
            return nil
        }
        var value: Value = 0
        for (groupIdx, group) in groups.enumerate() {
            value += Value(group.toInt << ((Self.groupsCount-groupIdx-1)*Self.groupBitsSize))
        }
        self.init(value: value)
    }

    public init?(groups: Group...) {
        self.init(groups: groups)
    }

    public init?(groups inputString: String) {
        let groupStrings = inputString.componentsSeparatedByString(Self.groupSeparator)
        guard groupStrings.count == Self.groupsCount else {
            return nil
        }
        self.init(groups: groupStrings.map { Group($0, radix: Self.groupRadix) ?? 0 })
    }
}

extension IPAddress {
    public static func bitsIndices() -> AnyGenerator<Int> {
        var currentIndex: Int = Self.bitsSize - 1
        return AnyGenerator {
            defer { currentIndex -= 1 }
            return currentIndex >= 0 ? Int(currentIndex) : .None
        }
    }

    public var bits: AnyGenerator<UInt> {
        let bitsIndices = Self.bitsIndices()
        return AnyGenerator {
            guard let bitIndex = bitsIndices.next() else {
                return .None
            }
            return UInt(((self.value & Value(0x1 << bitIndex)) >> bitIndex).toInt)
        }
    }
}

extension IPAddress {
    public static var groupsCount: Int {
        return Self.bitsSize / Self.groupBitsSize
    }

    public static func groupsIndices() -> AnyGenerator<Int> {
        var currentIndex: Int = 0
        return AnyGenerator {
            defer { currentIndex += 1 }
            return currentIndex < Self.groupsCount ? Int(currentIndex) : .None
        }
    }

    public var groups: AnyGenerator<Group> {
        let groupsIndices = Self.groupsIndices()
        return AnyGenerator {
            guard let index = groupsIndices.next() else {
                return .None
            }
            let group = (self.value >> Value(Self.groupBitsSize*(Self.groupsCount-index-1))) & Value(Group.max.toInt)
            return Group(group.toInt)
        }
    }
}

extension IPAddress {
    typealias Element = Group
    public init(arrayLiteral elements: Group...) {
        self = Self(groups: elements) ?? Self(value: 0)
    }
}

extension IPAddress {
    public init(stringLiteral value: String) {
        self = Self(groups: value) ?? Self(value: 0)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

// MARK: - Equaltable and Comparable

public func == <T: IPAddress>(lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

public func < <T: IPAddress>(lhs: T, rhs: T) -> Bool {
    return lhs.value < rhs.value
}

// MARK: - Arithmetic

public func + <T: IPAddress>(lhs: T, rhs: Int) -> T {
    return T(value: lhs.value + rhs)
}

// MARK: - Strings

extension IPAddress {
    public var description: String {
        return self.groups.map { String($0, radix: Self.groupRadix) }.joinWithSeparator(Self.groupSeparator)
    }
}

// ---------------------------------------------------------------------------------------------------------------------

// MARK: - Concrete Structures: IPv4

extension UInt32: IPAddressValueType {
    public var toInt: Int { return Int(self) }
}

public func << (lhs: UInt32, rhs: Int) -> UInt32 {
    return UInt32(min(Int(lhs) << rhs, Int(UInt32.max)))
}

public func >> (lhs: UInt32, rhs: Int) -> UInt32 {
    return UInt32(Int(lhs) >> rhs)
}

public func + (lhs: UInt32, rhs: Int) -> UInt32 {
    return UInt32(max(min(Int(lhs) + rhs, Int(UInt32.max)), Int(UInt32.min)))
}

extension UInt8: IPAddressGroupType {
    public var toInt: Int { return Int(self) }
}

public struct IPv4Address: IPAddress {
    public typealias Value = UInt32
    public typealias Group = UInt8
    public let value: UInt32

    public static let bitsSize = 32

    public static let groupBitsSize: Int = 8
    public static let groupRadix: Int = 10
    public static let groupSeparator: String = "."

    public init(value: UInt32) {
        self.value = value
    }
}
