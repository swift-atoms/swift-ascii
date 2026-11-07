extension ASCII.Classification {

    @inlinable
    public static func isAllWhitespace<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isWhitespace($0.underlying) }
    }

    @inlinable
    public static func isAllDigits<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isDigit($0.underlying) }
    }

    @inlinable
    public static func isAllLetters<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isLetter($0.underlying) }
    }

    @inlinable
    public static func isAllAlphanumeric<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isAlphanumeric($0.underlying) }
    }

    @inlinable
    public static func isAllControl<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isControl($0.underlying) }
    }

    @inlinable
    public static func isAllVisible<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isVisible($0.underlying) }
    }

    @inlinable
    public static func isAllPrintable<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.allSatisfy { Self.isPrintable($0.underlying) }
    }

    @inlinable
    public static func isAllLowercase<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        !bytes.contains { Self.isUppercase($0.underlying) }
    }

    @inlinable
    public static func isAllUppercase<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        !bytes.contains { Self.isLowercase($0.underlying) }
    }

    @inlinable
    public static func containsNonASCII<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.contains { $0.underlying >= 0x80 }
    }

    @inlinable
    public static func containsHexDigit<Bytes: Swift.Sequence>(_ bytes: Bytes) -> Bool
    where Bytes.Element == ASCII.Code {
        bytes.contains { Self.isHexDigit($0.underlying) }
    }
}
