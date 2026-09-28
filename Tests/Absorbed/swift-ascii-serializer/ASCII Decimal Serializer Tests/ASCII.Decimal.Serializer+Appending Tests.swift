#if Serializer
import ASCII
import Testing

@Suite
struct `Explicit decimal serialization appends to an existing buffer` {
    @Suite struct `Decimal digits append in order` {}
    @Suite struct `Integer boundaries append without overflow` {}
}

extension `Explicit decimal serialization appends to an existing buffer`.`Decimal digits append in order` {
    @Test
    func `Small positive integers append as decimal digits`() {
        var buffer: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int>().serialize(42, into: &buffer)
        #expect(buffer == "42".utf8.map(ASCII.Code.init))
    }

    @Test
    func `All decimal digits append in order`() {
        var buffer: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int>().serialize(1024, into: &buffer)
        #expect(buffer == "1024".utf8.map(ASCII.Code.init))
    }

    @Test
    func `Negative integers append with a leading minus sign`() {
        var buffer: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int>().serialize(-7, into: &buffer)
        #expect(buffer == "-7".utf8.map(ASCII.Code.init))
    }

    @Test
    func `Serialization preserves the existing prefix`() {
        var buffer: [ASCII.Code] = [ASCII.Code(0x41)]
        ASCII.Decimal.Serializer<Int>().serialize(5, into: &buffer)
        #expect(buffer == "A5".utf8.map(ASCII.Code.init))
    }
}

extension `Explicit decimal serialization appends to an existing buffer`.`Integer boundaries append without overflow` {
    @Test
    func `Zero appends as one decimal digit`() {
        var buffer: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int>().serialize(0, into: &buffer)
        #expect(buffer == [ASCII.Code(0x30)])
    }

    @Test
    func `The smallest Int64 appends without overflow`() {
        var buffer: [ASCII.Code] = []
        ASCII.Decimal.Serializer<Int64>().serialize(Int64.min, into: &buffer)
        #expect(buffer == "-9223372036854775808".utf8.map(ASCII.Code.init))
    }

    @Test
    func `The largest UInt64 appends without overflow`() {
        var buffer: [ASCII.Code] = []
        ASCII.Decimal.Serializer<UInt64>().serialize(UInt64.max, into: &buffer)
        #expect(buffer == "18446744073709551615".utf8.map(ASCII.Code.init))
    }
}
#endif
