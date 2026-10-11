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
        guard let byte = character.asciiValue else { return character }
        let converted = ASCII.Case.Conversion.convert(ASCII.Code(byte), to: `case`)
        return Character(UnicodeScalar(converted.underlying))
    }

    @_transparent
    public var isWhitespace: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isWhitespace
    }

    @_transparent
    public var isDigit: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isDigit
    }

    @_transparent
    public var isLetter: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isLetter
    }

    @inlinable
    public var isAlphanumeric: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isAlphanumeric
    }

    @inlinable
    public var isHexDigit: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isHexDigit
    }

    @_transparent
    public var isUppercase: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isUppercase
    }

    @_transparent
    public var isLowercase: Bool {
        guard let value = character.asciiValue else { return false }
        return ASCII.Code(value).isLowercase
    }
}
