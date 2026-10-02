#if Coder
import Map
import ASCII
import Byte
import Coder
import Carrier
import Cursor
import Parser
import Serializer
import Tagged
import Testing

@Suite
struct `Carrier Coder` {

    @Test
    func `a decimal coder represents a tagged limit`() throws(any Swift.Error) {
        let coder = decimal.map(representing: Limit.self)

        var buffer: [Byte] = []
        try coder.serialize(Limit(42), into: &buffer)
        #expect(buffer == "42")

        var input = buffer[...]
        #expect(try coder.parse(&input) == Limit(42))
        #expect(input.isEmpty)
    }

    @Test
    func `a decimal coder represents a hand written carrier`() throws(any Swift.Error) {
        let coder = decimal.map(representing: Celsius.self)

        var buffer: [Byte] = []
        try coder.serialize(Celsius(-7), into: &buffer)
        #expect(buffer == "-7")

        var input = buffer[...]
        #expect(try coder.parse(&input) == Celsius(-7))
    }

    @Test
    func `the represented coder reports the underlying failure`() {
        let coder = decimal.map(representing: Limit.self)
        var input: ArraySlice<Byte> = "x"
        #expect(throws: ASCII.Decimal.Error.self) {
            try coder.parse(&input)
        }
    }

    var decimal: ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Int> {
        .init()
    }
}

enum Counter {}

typealias Limit = Tagged<Counter, Int>

struct Celsius: Carrier.`Protocol`, Equatable {

    let underlying: Int

    init(_ underlying: Int) {
        self.underlying = underlying
    }
}
#endif
