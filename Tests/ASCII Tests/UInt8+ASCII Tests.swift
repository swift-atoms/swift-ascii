import Testing

@testable import ASCII

@Suite
struct `UInt8 exposes ASCII predicates and character conversion` {
    @Suite
    struct `Byte predicates classify ASCII character values` {
        @Test(arguments: [ASCII::ASCII.Code.htab.underlying, ASCII::ASCII.Code.lf.underlying, ASCII::ASCII.Code.cr.underlying, ASCII::ASCII.Code.sp.underlying])
        func `Whitespace bytes are recognized`(byte: UInt8) {
            #expect(byte.ascii.isWhitespace)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.0.underlying...ASCII::ASCII.Code.9.underlying))
        func `Digit bytes are recognized`(byte: UInt8) {
            #expect(byte.ascii.isDigit)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying))
        func `Uppercase letters are recognized`(byte: UInt8) {
            #expect(byte.ascii.isUppercase)
            #expect(byte.ascii.isLetter)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying))
        func `Lowercase letters are recognized`(byte: UInt8) {
            #expect(byte.ascii.isLowercase)
            #expect(byte.ascii.isLetter)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.nul.underlying...ASCII::ASCII.Code.us.underlying) + [ASCII::ASCII.Code.del.underlying])
        func `Control characters are recognized`(byte: UInt8) {
            #expect(byte.ascii.isControl)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.sp.underlying...ASCII::ASCII.Code.tilde.underlying))
        func `Printable characters are recognized`(byte: UInt8) {
            #expect(byte.ascii.isPrintable)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.exclamationPoint.underlying...ASCII::ASCII.Code.tilde.underlying))
        func `Visible characters are recognized`(byte: UInt8) {
            #expect(byte.ascii.isVisible)
        }
    }

    @Suite
    struct `Bytes convert valid ASCII characters` {
        @Test
        func `ASCII characters convert to their byte values`() {
            #expect(UInt8(ascii: "A") == ASCII::ASCII.Code.A.underlying)
            #expect(UInt8(ascii: "0") == ASCII::ASCII.Code.0.underlying)
            #expect(UInt8(ascii: " ") == ASCII::ASCII.Code.sp.underlying)
        }

        @Test
        func `Non-ASCII character returns nil`() {
            #expect(UInt8(ascii: "é") == nil)
            #expect(UInt8(ascii: "中") == nil)
        }
    }
}
