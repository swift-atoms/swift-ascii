public import Byte

extension ASCII.Code {

    @inlinable
    public var byte: Byte { Byte(bitPattern: underlying) }

    @inlinable
    public init(_ byte: Byte) throws(Self.Error) {
        guard byte.bitPattern < 0x80 else { throw .notASCII(byte: byte) }
        self.init(byte.bitPattern)
    }

    @inlinable
    public init(unchecked byte: Byte) {
        self.init(byte.bitPattern)
    }
}

extension ASCII.Code {

    @inlinable
    public static var zero: ASCII.Code { ASCII.Code(unchecked: Byte(bitPattern: 0x00)) }

    @inlinable
    public static var max: ASCII.Code { ASCII.Code(unchecked: Byte(bitPattern: 0x7F)) }
}

extension ASCII.Code {

    @inlinable
    public static func & (lhs: ASCII.Code, rhs: ASCII.Code) -> ASCII.Code {
        ASCII.Code(unchecked: Byte(bitPattern: lhs.underlying & rhs.underlying))
    }

    @inlinable
    public static func | (lhs: ASCII.Code, rhs: ASCII.Code) -> ASCII.Code {
        ASCII.Code(unchecked: Byte(bitPattern: lhs.underlying | rhs.underlying))
    }

    @inlinable
    public static func ^ (lhs: ASCII.Code, rhs: ASCII.Code) -> ASCII.Code {
        ASCII.Code(unchecked: Byte(bitPattern: lhs.underlying ^ rhs.underlying))
    }

    @inlinable
    public static func &= (lhs: inout ASCII.Code, rhs: ASCII.Code) {
        lhs = lhs & rhs
    }

    @inlinable
    public static func |= (lhs: inout ASCII.Code, rhs: ASCII.Code) {
        lhs = lhs | rhs
    }

    @inlinable
    public static func ^= (lhs: inout ASCII.Code, rhs: ASCII.Code) {
        lhs = lhs ^ rhs
    }
}
