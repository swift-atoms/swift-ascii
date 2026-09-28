#if Coder
import ASCII
import Byte
import Cursor
import Coder
import Parser
import Serializer
import Testing

@Suite
struct `ASCII.Decimal.Coder Tests` {

    @Test(arguments: [0, 7, 42, -7, Int.max, Int.min])
    func `round trips a signed integer through bytes`(value: Int) throws {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Int>()
        var bytes: [Byte] = []
        try coder.serialize(value, into: &bytes)
        var input = bytes[...]

        #expect(try coder.parse(&input) == value)
        #expect(input.isEmpty)
    }

    @Test(arguments: [0, 9, 255] as [UInt8])
    func `round trips an unsigned integer through bytes`(value: UInt8) throws {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], UInt8>()
        var bytes: [Byte] = []
        try coder.serialize(value, into: &bytes)
        var input = bytes[...]

        #expect(try coder.parse(&input) == value)
        #expect(input.isEmpty)
    }

    @Test
    func `an unsigned coder refuses a sign`() {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], UInt16>()
        var input = [Byte](utf8: "-5")[...]

        #expect(throws: ASCII.Decimal.Error.invalidSign) {
            try coder.parse(&input)
        }
    }

    @Test
    func `serializes the canonical decimal spelling`() throws {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Int32>()
        var bytes: [Byte] = []
        try coder.serialize(-1234, into: &bytes)

        #expect(bytes == "-1234".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `refuses input without digits`() {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Int>()
        var input = [Byte](utf8: "abc")[...]

        #expect(throws: ASCII.Decimal.Error.noDigits) {
            try coder.parse(&input)
        }
    }

    @Test
    func `stops at the first non-digit`() throws {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Int>()
        var input = [Byte](utf8: "12/rest")[...]

        #expect(try coder.parse(&input) == 12)
        #expect(input.first == Byte(bitPattern: 0x2F))
    }
}
#endif
