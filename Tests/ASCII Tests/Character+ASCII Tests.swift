import Testing

@testable import ASCII

@Suite
struct `Characters expose ASCII conversion and classification` {
    @Suite
    struct `Characters recognize ASCII whitespace` {
        @Test(arguments: [" ", "\t", "\n", "\r"])
        func `Whitespace characters are recognized`(char: Character) {
            #expect(char.ascii.isWhitespace)
        }

        @Test(arguments: ["a", "Z", "0", "!"])
        func `Non-whitespace characters are not recognized`(char: Character) {
            #expect(!char.ascii.isWhitespace)
        }
    }

    @Suite
    struct `Characters recognize ASCII digits` {
        @Test(arguments: Array<Character>("0123456789" as String))
        func `Digit characters are recognized`(char: Character) {
            #expect(char.ascii.isDigit)
        }

        @Test(arguments: ["a", "Z", " ", "!"])
        func `Non-digit characters are not recognized`(char: Character) {
            #expect(!char.ascii.isDigit)
        }
    }

    @Suite
    struct `Characters recognize ASCII letters` {
        @Test(arguments: Array(ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying))
        func `Uppercase letters A-Z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLetter, "Character '\(char)' should be a letter")
            #expect(char.ascii.isUppercase, "Character '\(char)' should be uppercase")
        }

        @Test(arguments: Array(ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying))
        func `Lowercase letters a-z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLetter, "Character '\(char)' should be a letter")
            #expect(char.ascii.isLowercase, "Character '\(char)' should be lowercase")
        }

        @Test(arguments: ["0", "9", " ", "!", "@"])
        func `Non-letter characters are not recognized`(char: Character) {
            #expect(!char.ascii.isLetter)
        }
    }

    @Suite
    struct `Characters recognize ASCII letters and digits` {
        @Test(arguments: Array<Character>("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" as String))
        func `Letters and digits are alphanumeric`(char: Character) {
            #expect(char.ascii.isAlphanumeric, "Character '\(char)' should be alphanumeric")
        }

        @Test(arguments: [
            " ", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "=",
        ])
        func `Special characters are not alphanumeric`(char: Character) {
            #expect(!char.ascii.isAlphanumeric)
        }
    }

    @Suite
    struct `Characters recognize hexadecimal digits` {
        @Test(arguments: Array<Character>("0123456789ABCDEFabcdef" as String))
        func `Every hexadecimal digit is recognized`(char: Character) {
            #expect(char.ascii.isHexDigit, "Character '\(char)' should be a hex digit")
        }

        @Test(arguments: ["G", "g", "Z", "z", " ", "!", "@"])
        func `Non-hex characters are not recognized`(char: Character) {
            #expect(!char.ascii.isHexDigit)
        }
    }

    @Suite
    struct `Characters distinguish uppercase and lowercase letters` {
        @Test(arguments: Array(ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying))
        func `Uppercase letters A-Z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isUppercase, "Character '\(char)' should be uppercase")
            #expect(!char.ascii.isLowercase, "Character '\(char)' should not be lowercase")
        }

        @Test(arguments: Array(ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying))
        func `Lowercase letters a-z are recognized`(ascii: UInt8) {
            let char = Character(UnicodeScalar(ascii))
            #expect(char.ascii.isLowercase, "Character '\(char)' should be lowercase")
            #expect(!char.ascii.isUppercase, "Character '\(char)' should not be uppercase")
        }

        @Test(arguments: ["0", "9", " ", "!", "@", "#"])
        func `Non-letter characters are neither uppercase nor lowercase`(char: Character) {
            #expect(!char.ascii.isUppercase)
            #expect(!char.ascii.isLowercase)
        }
    }

    @Suite
    struct `Characters validate ASCII membership` {
        @Test
        func `Character validation returns character if valid ASCII`() {
            let char: Character = "A"
            #expect(char.ascii() == "A")
        }

        @Test
        func `Character validation returns nil for non-ASCII`() {
            let char: Character = "🌍"
            #expect(char.ascii() == nil)
        }

        @Test(arguments: Array(0x00...0x7F))
        func `All ASCII bytes validate`(byte: UInt8) {
            let char = Character(UnicodeScalar(byte))
            #expect(char.ascii() != nil)
        }
    }

    @Suite
    struct `Characters convert ASCII case while preserving other characters` {
        @Test
        func `ASCII case conversion converts to uppercase`() {
            #expect(Character("a").ascii(case: .upper) == "A")
            #expect(Character("z").ascii(case: .upper) == "Z")
        }

        @Test
        func `ASCII case conversion converts to lowercase`() {
            #expect(Character("A").ascii(case: .lower) == "a")
            #expect(Character("Z").ascii(case: .lower) == "z")
        }

        @Test
        func `ASCII case conversion preserves non-letters`() {
            #expect(Character("5").ascii(case: .upper) == "5")
            #expect(Character(" ").ascii(case: .lower) == " ")
        }

        @Test
        func `ASCII case conversion preserves non-ASCII`() {
            #expect(Character("🌍").ascii(case: .upper) == "🌍")
            #expect(Character("é").ascii(case: .lower) == "é")
        }
    }

    @Suite
    struct `Characters are constructed from ASCII bytes` {
        @Test
        func `ASCII initialization creates character from valid byte`() {
            #expect(Character(ascii: 0x41) == "A")
            #expect(Character(ascii: 0x61) == "a")
            #expect(Character(ascii: 0x30) == "0")
        }

        @Test
        func `ASCII initialization returns nil for non-ASCII byte`() {
            #expect(Character(ascii: 0xFF) == nil)
            #expect(Character(ascii: 0x80) == nil)
        }

        @Test(arguments: Array(0x00...0x7F))
        func `ASCII initialization works for all ASCII bytes`(byte: UInt8) {
            #expect(Character(ascii: byte) != nil)
        }

        @Test
        func `Unchecked creates character without validation`() {
            #expect(Character.ascii.unchecked(0x41) == "A")
            #expect(Character.ascii.unchecked(0x61) == "a")
        }

        @Test
        func `ASCII characters survive conversion to UInt8 and back`() {
            let original: Character = "X"
            let byte = UInt8(ascii: original)!
            let restored = Character(ascii: byte)!
            #expect(restored == original)
        }
    }
}
