extension ASCII {

    public enum Classification {}
}

extension ASCII.Classification {

    @usableFromInline
    internal static let _digit: UInt8 = 0x01
    @usableFromInline
    internal static let _upper: UInt8 = 0x02
    @usableFromInline
    internal static let _lower: UInt8 = 0x04
    @usableFromInline
    internal static let _hexUpper: UInt8 = 0x08
    @usableFromInline
    internal static let _hexLower: UInt8 = 0x10
    @usableFromInline
    internal static let _whitespace: UInt8 = 0x20
    @usableFromInline
    internal static let _control: UInt8 = 0x40
    @usableFromInline
    internal static let _printable: UInt8 = 0x80

    @usableFromInline
    internal static let _classTable: [UInt8] = {
        var table = [UInt8](repeating: 0, count: 128)

        (0x00...0x1F).forEach { i in
            table[i] = _control
        }

        table[0x7F] = _control

        table[0x09] |= _whitespace
        table[0x0A] |= _whitespace
        table[0x0D] |= _whitespace
        table[0x20] = _whitespace | _printable

        (0x21...0x7E).forEach { i in
            table[i] |= _printable
        }

        (0x30...0x39).forEach { i in
            table[i] |= _digit
        }

        (0x41...0x5A).forEach { i in
            table[i] |= _upper
        }

        (0x61...0x7A).forEach { i in
            table[i] |= _lower
        }

        (0x41...0x46).forEach { i in
            table[i] |= _hexUpper
        }

        (0x61...0x66).forEach { i in
            table[i] |= _hexLower
        }

        return table
    }()

    @_transparent
    @usableFromInline
    internal static func _lookup(_ byte: UInt8) -> UInt8 {
        byte < 128 ? _classTable[Int(byte)] : 0
    }
}

extension ASCII.Classification {

    @_transparent
    public static func isWhitespace(_ byte: UInt8) -> Bool {
        _lookup(byte) & _whitespace != 0
    }

    @_transparent
    public static func isControl(_ byte: UInt8) -> Bool {
        byte <= 0x1F || byte == 0x7F
    }

    @_transparent
    public static func isVisible(_ byte: UInt8) -> Bool {
        byte >= 0x21 && byte <= 0x7E
    }

    @_transparent
    public static func isPrintable(_ byte: UInt8) -> Bool {
        byte >= 0x20 && byte <= 0x7E
    }

    @_transparent
    public static func isDigit(_ byte: UInt8) -> Bool {
        (byte &- 0x30) < 10
    }

    @_transparent
    public static func isHexDigit(_ byte: UInt8) -> Bool {
        let flags = _lookup(byte)
        return flags & (_digit | _hexUpper | _hexLower) != 0
    }

    @_transparent
    public static func isLetter(_ byte: UInt8) -> Bool {
        (byte &- 0x41) < 26 || (byte &- 0x61) < 26
    }

    @_transparent
    public static func isUppercase(_ byte: UInt8) -> Bool {
        (byte &- 0x41) < 26
    }

    @_transparent
    public static func isLowercase(_ byte: UInt8) -> Bool {
        (byte &- 0x61) < 26
    }

    @_transparent
    public static func isAlphanumeric(_ byte: UInt8) -> Bool {
        let flags = _lookup(byte)
        return flags & (_digit | _upper | _lower) != 0
    }
}
