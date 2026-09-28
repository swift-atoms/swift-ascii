#if Coder
import ASCII
import Byte
import Cursor
import Testing

@Suite
struct `Decimal coding configuration` {
    typealias Decimal = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Int>

    @Test(arguments: [0, 7, 99, -7, -99])
    func `fixed width counts magnitude digits`(_ value: Int) throws {
        let coder = Decimal(count: .exactly(2))
        var bytes: [Byte] = []
        try coder.serialize(value, into: &bytes)
        #expect(bytes.count == (value < 0 ? 3 : 2))
        var input = bytes[...]
        #expect(try coder.parse(&input) == value)
        #expect(input.isEmpty)
        if value == -7 { #expect(bytes == [Byte](utf8: "-07")) }
        if value == 0 { #expect(bytes == [Byte](utf8: "00")) }
    }

    @Test
    func `configured failures precede output`() {
        let cases: [(Decimal, Int, ASCII.Decimal.Error)] = [
            (.init(sign: .none), -1, .invalidSign),
            (.init(count: .exactly(2)), 100, .overflow),
            (.init(count: .atMost(2)), -100, .overflow),
            (.init(count: .exactly(-1)), 1, .invalidCount(-1)),
            (.init(count: .atMost(-1)), 1, .invalidCount(-1)),
            (.init(count: .exactly(0)), 0, .insufficientDigits),
            (.init(count: .atMost(0)), 0, .noDigits),
        ]
        for (coder, value, error) in cases {
            var buffer = [Byte](utf8: "prefix:")
            #expect(throws: error) { try coder.serialize(value, into: &buffer) }
            #expect(buffer == [Byte](utf8: "prefix:"))
        }
    }

    @Test(arguments: UInt8.min...UInt8.max)
    func `every byte fits exactly three digits`(_ value: UInt8) throws {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], UInt8>(
            sign: .none, count: .exactly(3)
        )
        var bytes: [Byte] = []
        try coder.serialize(value, into: &bytes)
        #expect(bytes.count == 3)
        var input = bytes[...]
        #expect(try coder.parse(&input) == value)
        #expect(input.isEmpty)
    }

    @Test
    func `at most emits no unnecessary padding`() throws {
        let coder = Decimal(count: .atMost(2))
        var buffer: [Byte] = []
        try coder.serialize(7, into: &buffer)
        #expect(buffer == [Byte](utf8: "7"))
        var input = [Byte](utf8: "07/rest")[...]
        #expect(try coder.parse(&input) == 7)
        #expect(input.elementsEqual([Byte](utf8: "/rest")))
    }

    @Test
    func `canonicalization drops explicit plus and leading zeros`() throws {
        let coder = Decimal()
        var input = [Byte](utf8: "+0007!")[...]
        let value = try coder.parse(&input)
        #expect(input.elementsEqual([Byte](utf8: "!")))
        var output: [Byte] = []
        try coder.serialize(value, into: &output)
        #expect(output == [Byte](utf8: "7"))
    }

    @Test
    func `overflow restores the entire number`() {
        let coder = ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], UInt8>()
        var input = [Byte](utf8: "256;")[...]
        #expect(throws: ASCII.Decimal.Error.overflow) { try coder.parse(&input) }
        #expect(input.elementsEqual([Byte](utf8: "256;")))
    }

    @Test
    func `fixed widths frame adjacent fields`() throws {
        let coder = Decimal(sign: .none, count: .exactly(2))
        var buffer: [Byte] = []
        try coder.serialize(7, into: &buffer)
        try coder.serialize(42, into: &buffer)
        #expect(buffer == [Byte](utf8: "0742"))
        var input = buffer[...]
        #expect(try coder.parse(&input) == 7)
        #expect(try coder.parse(&input) == 42)
        #expect(input.isEmpty)
    }
}
#endif
