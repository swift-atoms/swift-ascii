#if Parser
import ASCII
import ASCII_Parser_Test_Support
import Byte
import Cursor
import Testing

private typealias Cursor = ArraySlice<Byte>

@Suite
struct `ASCII.Decimal.Parser Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct `Count Policy` {}
    @Suite struct `Sign Policy` {}
}

extension `ASCII.Decimal.Parser Tests`.Unit {
    @Test
    func `parses single digit`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x35)

        let result = try parser.parse(&input)

        #expect(result == 5)
        #expect(input.isEmpty)
    }

    @Test
    func `parses multi-digit number`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x33)

        let result = try parser.parse(&input)

        #expect(result == 123)
        #expect(input.isEmpty)
    }

    @Test
    func `stops at non-digit byte`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x34, 0x32, 0x2E, 0x35)

        let result = try parser.parse(&input)

        #expect(result == 42)
        #expect(input.first == Byte(bitPattern: 0x2E))
    }

    @Test
    func `parses into UInt16`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, UInt16>()
        var input = ArraySlice<Byte>.bytes(0x38, 0x30, 0x38, 0x30)

        let result = try parser.parse(&input)

        #expect(result == 8080)
    }

    @Test
    func `parses zero`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x30)

        let result = try parser.parse(&input)

        #expect(result == 0)
    }

    @Test
    func `parses leading zeros`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x30, 0x30, 0x35)

        let result = try parser.parse(&input)

        #expect(result == 5)
        #expect(input.isEmpty)
    }
}

extension `ASCII.Decimal.Parser Tests`.`Edge Case` {
    @Test
    func `fails on empty input`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes()

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `fails on non-digit first byte`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x41)

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `detects UInt8 overflow`() {
        let parser = ASCII.Decimal.Parser<Cursor, UInt8>()
        var input = ArraySlice<Byte>.bytes(0x32, 0x35, 0x36)

        #expect(throws: ASCII.Decimal.Error.overflow) {
            try parser.parse(&input)
        }
    }

    @Test
    func `boundary value UInt8 max`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, UInt8>()
        var input = ArraySlice<Byte>.bytes(0x32, 0x35, 0x35)

        let result = try parser.parse(&input)

        #expect(result == 255)
    }
}

extension `ASCII.Decimal.Parser Tests`.`Count Policy` {
    @Test
    func `greedy default consumes all digits`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .greedy)
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x33, 0x34)

        let result = try parser.parse(&input)

        #expect(result == 1234)
        #expect(input.isEmpty)
    }

    @Test
    func `exactly consumes exactly n digits and stops`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .exactly(4))
        var input = ArraySlice<Byte>.bytes(0x32, 0x30, 0x32, 0x36, 0x2D, 0x30, 0x36)

        let result = try parser.parse(&input)

        #expect(result == 2026)
        #expect(input.first == Byte(bitPattern: 0x2D))
    }

    @Test
    func `exactly stops before a further digit`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .exactly(2))
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x33, 0x34)

        let result = try parser.parse(&input)

        #expect(result == 12)
        #expect(input.first == Byte(bitPattern: 0x33))
    }

    @Test
    func `exactly shortfall throws insufficientDigits`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .exactly(4))
        var input = ArraySlice<Byte>.bytes(0x31, 0x32)

        #expect(throws: ASCII.Decimal.Error.insufficientDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `exactly shortfall on non-digit throws insufficientDigits`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .exactly(3))
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x2E)

        #expect(throws: ASCII.Decimal.Error.insufficientDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `exactly zero is degenerate and throws`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .exactly(0))
        var input = ArraySlice<Byte>.bytes(0x31, 0x32)

        #expect(throws: ASCII.Decimal.Error.insufficientDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `exactly preserves overflow check`() {
        let parser = ASCII.Decimal.Parser<Cursor, UInt8>(count: .exactly(3))
        var input = ArraySlice<Byte>.bytes(0x32, 0x35, 0x36)

        #expect(throws: ASCII.Decimal.Error.overflow) {
            try parser.parse(&input)
        }
    }

    @Test
    func `atMost caps and leaves the remainder`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .atMost(2))
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x33, 0x34, 0x35)

        let result = try parser.parse(&input)

        #expect(result == 12)
        #expect(input.first == Byte(bitPattern: 0x33))
    }

    @Test
    func `atMost stops early at a non-digit`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .atMost(5))
        var input = ArraySlice<Byte>.bytes(0x37, 0x2C)

        let result = try parser.parse(&input)

        #expect(result == 7)
        #expect(input.first == Byte(bitPattern: 0x2C))
    }

    @Test
    func `atMost bigger than available consumes all`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .atMost(10))
        var input = ArraySlice<Byte>.bytes(0x34, 0x32)

        let result = try parser.parse(&input)

        #expect(result == 42)
        #expect(input.isEmpty)
    }

    @Test
    func `atMost requires at least one digit`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(count: .atMost(3))
        var input = ArraySlice<Byte>.bytes(0x41)

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
    }
}

extension `ASCII.Decimal.Parser Tests`.`Sign Policy` {
    @Test
    func `none default leaves a leading plus unconsumed`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x2B, 0x31, 0x32, 0x33)

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
        #expect(input.first == Byte(bitPattern: 0x2B))
    }

    @Test
    func `none default leaves a leading minus unconsumed`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>()
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32, 0x33)

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
        #expect(input.first == Byte(bitPattern: 0x2D))
    }

    @Test
    func `optional consumes a leading plus`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2B, 0x31, 0x32, 0x33)

        let result = try parser.parse(&input)

        #expect(result == 123)
        #expect(input.isEmpty)
    }

    @Test
    func `optional consumes a leading minus`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32, 0x33)

        let result = try parser.parse(&input)

        #expect(result == -123)
        #expect(input.isEmpty)
    }

    @Test
    func `optional with no sign is positive`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x33)

        let result = try parser.parse(&input)

        #expect(result == 123)
        #expect(input.isEmpty)
    }

    @Test
    func `Int8 minimum is reachable`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int8>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32, 0x38)

        let result = try parser.parse(&input)

        #expect(result == -128)
        #expect(result == Int8.min)
    }

    @Test
    func `Int8 below minimum overflows`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int8>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32, 0x39)

        #expect(throws: ASCII.Decimal.Error.overflow) {
            try parser.parse(&input)
        }
    }

    @Test
    func `Int8 maximum is reachable`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int8>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x37)

        let result = try parser.parse(&input)

        #expect(result == 127)
        #expect(result == Int8.max)
    }

    @Test
    func `Int8 above maximum overflows`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int8>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x31, 0x32, 0x38)

        #expect(throws: ASCII.Decimal.Error.overflow) {
            try parser.parse(&input)
        }
    }

    @Test
    func `negative into unsigned throws invalidSign`() {
        let parser = ASCII.Decimal.Parser<Cursor, UInt8>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2D, 0x35)

        #expect(throws: ASCII.Decimal.Error.invalidSign) {
            try parser.parse(&input)
        }
        #expect(input.first == Byte(bitPattern: 0x2D))
    }

    @Test
    func `positive into unsigned is accepted`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, UInt8>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2B, 0x35)

        let result = try parser.parse(&input)

        #expect(result == 5)
        #expect(input.isEmpty)
    }

    @Test
    func `lone minus has no digits`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2D)

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
        #expect(input.first == Byte(bitPattern: 0x2D))
    }

    @Test
    func `lone plus has no digits`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional)
        var input = ArraySlice<Byte>.bytes(0x2B)

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try parser.parse(&input)
        }
        #expect(input.first == Byte(bitPattern: 0x2B))
    }

    @Test
    func `optional sign with exactly shortfall throws insufficientDigits`() {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional, count: .exactly(3))
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32)

        #expect(throws: ASCII.Decimal.Error.insufficientDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `optional sign with exactly exact count`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional, count: .exactly(3))
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32, 0x33)

        let result = try parser.parse(&input)

        #expect(result == -123)
        #expect(input.isEmpty)
    }

    @Test
    func `optional sign with exactly leaves the remainder`() throws {
        let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional, count: .exactly(3))
        var input = ArraySlice<Byte>.bytes(0x2D, 0x31, 0x32, 0x33, 0x34)

        let result = try parser.parse(&input)

        #expect(result == -123)
        #expect(input.first == Byte(bitPattern: 0x34))
    }
}


extension `ASCII.Decimal.Parser Tests`.`Count Policy` {
    @Test(arguments: [-1, Int.min])
    func negativeLimitsRejectBeforeConsumingInput(_ limit: Int) {
        let original = [Byte](utf8: "xx-11!").dropFirst(2)
        for count in [ASCII.Digits.Count.exactly(limit), .atMost(limit)] {
            var input = original
            let parser = ASCII.Decimal.Parser<Cursor, Int>(sign: .optional, count: count)
            #expect(throws: ASCII.Decimal.Error.invalidCount(limit)) { try parser.parse(&input) }
            #expect(input == original)
            #expect(input.startIndex == original.startIndex)
        }
    }
}
#endif
