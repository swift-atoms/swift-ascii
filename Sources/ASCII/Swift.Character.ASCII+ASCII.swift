extension Swift.Character.ASCII {

    @inlinable
    public static func unchecked(_ byte: UInt8) -> Character {
        Character(UnicodeScalar(byte))
    }

    @inlinable
    public func callAsFunction() -> Character? {
        character.isASCII ? character : nil
    }

    @inlinable
    public func callAsFunction(case: ASCII::ASCII.Case) -> Character {
        guard let byte = UInt8(ascii: character) else { return character }
        let converted = ASCII.Case.Conversion.convert(ASCII.Code(byte), to: `case`)
        return Character(UnicodeScalar(converted.underlying))
    }

    @_transparent
    public var isWhitespace: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isWhitespace
    }

    @_transparent
    public var isDigit: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isDigit
    }

    @_transparent
    public var isLetter: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isLetter
    }

    @inlinable
    public var isAlphanumeric: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isAlphanumeric
    }

    @inlinable
    public var isHexDigit: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isHexDigit
    }

    @_transparent
    public var isUppercase: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isUppercase
    }

    @_transparent
    public var isLowercase: Bool {
        guard let value = UInt8(ascii: character) else { return false }
        return value.ascii.isLowercase
    }
}
