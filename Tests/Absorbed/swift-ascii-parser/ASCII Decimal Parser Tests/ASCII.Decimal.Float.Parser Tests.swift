#if Parser
import ASCII
import Byte
import Cursor
import Testing

private typealias Cursor = ArraySlice<Byte>

@Suite
struct `ASCII.Decimal.Float.Parser Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

private func bytes(_ s: String) -> Cursor {
    [Byte](utf8: s)[...]
}

private func parse(_ s: String) throws(ASCII.Decimal.Float.Error) -> Double {
    let parser = ASCII.Decimal.Float.Parser<Cursor>()
    var input = bytes(s)
    return try parser.parse(&input)
}

extension `ASCII.Decimal.Float.Parser Tests`.Unit {

    @Test
    func `integer literal`() throws {
        #expect(try parse("42") == 42.0)
        #expect(try parse("0") == 0.0)
        #expect(try parse("1") == 1.0)
    }

    @Test
    func `negative integer`() throws {
        #expect(try parse("-1") == -1.0)
        #expect(try parse("-42") == -42.0)
    }

    @Test
    func `explicit positive sign`() throws {
        #expect(try parse("+1") == 1.0)
        #expect(try parse("+42") == 42.0)
    }

    @Test
    func `simple fraction`() throws {
        #expect(try parse("3.14") == 3.14)
        #expect(try parse("0.5") == 0.5)
        #expect(try parse("0.25") == 0.25)
    }

    @Test
    func `negative fraction`() throws {
        #expect(try parse("-3.14") == -3.14)
        #expect(try parse("-0.001") == -0.001)
    }

    @Test
    func `exponent positive`() throws {
        #expect(try parse("1e2") == 100.0)
        #expect(try parse("1.5e3") == 1500.0)
        #expect(try parse("3.14e2") == 314.0)
    }

    @Test
    func `exponent negative`() throws {
        #expect(try parse("1e-2") == 0.01)
        #expect(try parse("1.5e-3") == 0.0015)
    }

    @Test
    func `exponent capital E`() throws {
        #expect(try parse("1E2") == 100.0)
        #expect(try parse("1.5E-3") == 0.0015)
    }

    @Test
    func `exponent explicit positive sign`() throws {
        #expect(try parse("1e+2") == 100.0)
        #expect(try parse("1.5e+3") == 1500.0)
    }

    @Test
    func `negative zero`() throws {
        let v = try parse("-0")
        #expect(v == 0.0)
        #expect(v.sign == .minus)
    }

    @Test
    func `negative zero with fraction`() throws {
        let v = try parse("-0.0")
        #expect(v == 0.0)
        #expect(v.sign == .minus)
    }

    @Test
    func `leading zeros`() throws {
        #expect(try parse("007") == 7.0)
        #expect(try parse("01.5") == 1.5)
    }

    @Test
    func `trailing fractional zeros`() throws {
        #expect(try parse("1.500") == 1.5)
        #expect(try parse("3.140000") == 3.14)
    }
}

extension `ASCII.Decimal.Float.Parser Tests`.`Edge Case` {

    @Test
    func `empty input`() throws {
        let parser = ASCII.Decimal.Float.Parser<Cursor>()
        var input = bytes("")
        #expect(throws: ASCII.Decimal.Float.Error.empty) {
            try parser.parse(&input)
        }
    }

    @Test
    func `sign only`() throws {
        let parser = ASCII.Decimal.Float.Parser<Cursor>()
        var input = bytes("-")
        #expect(throws: ASCII.Decimal.Float.Error.missingDigits) {
            try parser.parse(&input)
        }
    }

    @Test
    func `stops at non-numeric byte`() throws {
        let parser = ASCII.Decimal.Float.Parser<Cursor>()
        var input = bytes("3.14abc")
        let v = try parser.parse(&input)
        #expect(v == 3.14)
        #expect(input.first == Byte(bitPattern: 0x61))
    }

    @Test
    func `rewinds trailing e with no digits`() throws {

        let parser = ASCII.Decimal.Float.Parser<Cursor>()
        var input = bytes("1e")
        let v = try parser.parse(&input)
        #expect(v == 1.0)
        #expect(input.first == Byte(bitPattern: 0x65))
    }

    @Test
    func `large positive exponent overflows to infinity`() throws {
        let v = try parse("1e400")
        #expect(v == .infinity)
    }

    @Test
    func `large negative exponent underflows to zero`() throws {
        let v = try parse("1e-400")
        #expect(v == 0.0)
    }

    @Test
    func `subnormal value`() throws {

        let v = try parse("1e-310")
        #expect(v > 0)
        #expect(v < Double.leastNormalMagnitude)
    }

    @Test
    func `smallest subnormal`() throws {

        let v = try parse("5e-324")
        #expect(v == Double.leastNonzeroMagnitude)
    }

    @Test
    func `pi to many digits`() throws {
        let pi = 3.141592653589793
        #expect(try parse("3.141592653589793") == pi)
        #expect(try parse("3.14159265358979323846") == pi)
    }

    @Test
    func `canada coordinate shape`() throws {

        let v = try parse("-65.613616999999977")
        #expect(v == -65.613616999999977)
    }

    @Test
    func `19-digit mantissa boundary`() throws {

        #expect(try parse("1234567890123456789") == 1234567890123456789.0)
    }

    @Test
    func `20-digit mantissa slow path`() throws {

        let v = try parse("12345678901234567890")
        #expect(v == 12345678901234567890.0)
    }
}

extension `ASCII.Decimal.Float.Parser Tests`.Integration {

    @Test
    func `parses then stops on whitespace`() throws {
        let parser = ASCII.Decimal.Float.Parser<Cursor>()
        var input = bytes("42.5 next")
        let v = try parser.parse(&input)
        #expect(v == 42.5)
        #expect(input.first == Byte(bitPattern: 0x20))
    }

    @Test
    func `parses then stops on comma`() throws {
        let parser = ASCII.Decimal.Float.Parser<Cursor>()
        var input = bytes("1.5,2.5")
        let v = try parser.parse(&input)
        #expect(v == 1.5)
        #expect(input.first == Byte(bitPattern: 0x2C))
    }

    @Test
    func `agrees with stdlib on JSON-typical numbers`() throws {
        let cases: [String] = [
            "0", "0.0", "1", "1.0", "-1", "1e10", "1e-10",
            "3.14", "2.718281828", "-273.15",
            "6.022e23", "1.602176634e-19",
            "1.7976931348623157e308",
            "2.2250738585072014e-308",
            "0.1", "0.2", "0.3",
        ]
        for s in cases {
            let mine = try parse(s)
            let stdlib = Double(s)!
            #expect(mine == stdlib, "mismatch on \(s): mine=\(mine) stdlib=\(stdlib)")
        }
    }

    @Test
    func `agrees with stdlib on tricky exponents`() throws {

        let cases: [String] = [
            "1e23", "1e24", "1e50", "1e100", "1e-50",
            "1.234567890123456789e25",
            "9.999999999999999e307",
            "1.5e-200", "1.5e200",
        ]
        for s in cases {
            let mine = try parse(s)
            let stdlib = Double(s)!
            #expect(mine == stdlib, "mismatch on \(s): mine=\(mine) stdlib=\(stdlib)")
        }
    }

    @Test
    func `agrees with stdlib on round-to-even edges`() throws {

        let cases: [String] = [
            "1.0", "2.0", "0.5",
            "1.7976931348623157e308",
            "5e-324",

            "7.3177701707893310e+15",
            "2.2250738585072011e-308",
        ]
        for s in cases {
            let mine = try parse(s)
            let stdlib = Double(s)!
            #expect(
                mine == stdlib,
                "mismatch on \(s): mine=\(mine.bitPattern.hex) stdlib=\(stdlib.bitPattern.hex)"
            )
        }
    }
}

extension UInt64 {
    fileprivate var hex: String { String(self, radix: 16) }
}


extension `ASCII.Decimal.Float.Parser Tests`.Integration {
    @Test(arguments: [
        "1e400", "10000000000000000000e381",
        "-1e400", "-10000000000000000000e381",
        "1e-400", "10000000000000000000e-419",
        "-1e-400", "-10000000000000000000e-419"
    ])
    func exponentExtremesAgreeAcrossMantissaPaths(_ text: String) throws {
        let expected = try #require(Double(text))
        var input = bytes(text + ",tail")
        let value = try ASCII.Decimal.Float.Parser<Cursor>().parse(&input)
        #expect(value.bitPattern == expected.bitPattern)
        #expect(input.map(\.bitPattern) == Array(",tail".utf8))
        let storage = [Byte](utf8: text)
        let contiguous = try ASCII.Decimal.Float.parse(storage.span)
        #expect(contiguous.bitPattern == expected.bitPattern)
    }
}
#endif
