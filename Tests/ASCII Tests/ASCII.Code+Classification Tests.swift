import Testing

@testable import ASCII

@Suite
struct `ASCII Code classification` {
    @Suite
    struct `Byte predicates classify ASCII character values` {
        @Test(arguments: [
            ASCII::ASCII.Code.htab.underlying, ASCII::ASCII.Code.lf.underlying,
            ASCII::ASCII.Code.cr.underlying, ASCII::ASCII.Code.sp.underlying,
        ])
        func `Whitespace bytes are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isWhitespace)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.0.underlying...ASCII::ASCII.Code.9.underlying))
        func `Digit bytes are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isDigit)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying))
        func `Uppercase letters are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isUppercase)
            #expect(ASCII::ASCII.Code(byte).isLetter)
        }

        @Test(arguments: Array(ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying))
        func `Lowercase letters are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isLowercase)
            #expect(ASCII::ASCII.Code(byte).isLetter)
        }

        @Test(
            arguments: Array(ASCII::ASCII.Code.nul.underlying...ASCII::ASCII.Code.us.underlying) + [
                ASCII::ASCII.Code.del.underlying
            ]
        )
        func `Control characters are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isControl)
        }

        @Test(
            arguments: Array(ASCII::ASCII.Code.sp.underlying...ASCII::ASCII.Code.tilde.underlying)
        )
        func `Printable characters are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isPrintable)
        }

        @Test(
            arguments: Array(
                ASCII::ASCII.Code.exclamationPoint.underlying...ASCII::ASCII.Code.tilde.underlying
            )
        )
        func `Visible characters are recognized`(byte: UInt8) {
            #expect(ASCII::ASCII.Code(byte).isVisible)
        }
    }
}
