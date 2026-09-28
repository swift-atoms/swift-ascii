#if Serializer
import ASCII
import Serializer
import Testing

@Suite
struct `Fixed width integers use an explicit decimal serializer` {

    @Test
    func `An explicit decimal serializer encodes Int values`() {
        let codes = ASCII.Decimal.Serializer<Int>().serialize(Int(42))
        #expect(codes == "42".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes UInt values`() {
        let codes = ASCII.Decimal.Serializer<UInt>().serialize(UInt(100))
        #expect(codes == "100".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes Int8 values`() {
        let codes = ASCII.Decimal.Serializer<Int8>().serialize(Int8(-128))
        #expect(codes == "-128".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes UInt8 values`() {
        let codes = ASCII.Decimal.Serializer<UInt8>().serialize(UInt8(255))
        #expect(codes == "255".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes Int16 values`() {
        let codes = ASCII.Decimal.Serializer<Int16>().serialize(Int16(-1))
        #expect(codes == "-1".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes UInt16 values`() {
        let codes = ASCII.Decimal.Serializer<UInt16>().serialize(UInt16(8080))
        #expect(codes == "8080".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes Int32 values`() {
        let codes = ASCII.Decimal.Serializer<Int32>().serialize(Int32(0))
        #expect(codes == "0".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes UInt32 values`() {
        let codes = ASCII.Decimal.Serializer<UInt32>().serialize(UInt32(1_000_000))
        #expect(codes == "1000000".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes Int64 values`() {
        let codes = ASCII.Decimal.Serializer<Int64>().serialize(Int64.min)
        #expect(codes == "-9223372036854775808".utf8.map(ASCII.Code.init))
    }

    @Test
    func `An explicit decimal serializer encodes UInt64 values`() {
        let codes = ASCII.Decimal.Serializer<UInt64>().serialize(UInt64.max)
        #expect(codes == "18446744073709551615".utf8.map(ASCII.Code.init))
    }
}
#endif
