#if Serializer
import Serializer
import ASCII
import Testing

@Suite
struct `ASCII.Binary.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `ASCII.Binary.Serializer Tests`.Unit {
    @Test
    func `serializes zero`() {
        let serializer = ASCII.Binary.Serializer<UInt8>()
        let codes = serializer.serialize(0)
        #expect(codes == [ASCII.Code(0x30)])
    }

    @Test
    func `serializes single digit`() {
        let serializer = ASCII.Binary.Serializer<UInt8>()
        let codes = serializer.serialize(1)
        #expect(codes == [ASCII.Code(0x31)])
    }

    @Test
    func `serializes multi-digit`() {
        let serializer = ASCII.Binary.Serializer<UInt8>()
        let codes = serializer.serialize(11)
        #expect(codes == "1011".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes into existing buffer`() {
        let serializer = ASCII.Binary.Serializer<UInt8>()
        var buffer: [ASCII.Code] = [ASCII.Code(0x41), ASCII.Code(0x42)]
        serializer.serialize(5, into: &buffer)
        #expect(buffer == "AB101".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes negative`() {
        let serializer = ASCII.Binary.Serializer<Int8>()
        let codes = serializer.serialize(-1)
        #expect(codes == [ASCII.Code(0x2D), ASCII.Code(0x31)])
    }
}

extension `ASCII.Binary.Serializer Tests`.`Edge Case` {
    @Test
    func `serializes UInt8 max`() {
        let serializer = ASCII.Binary.Serializer<UInt8>()
        let codes = serializer.serialize(.max)
        #expect(codes == "11111111".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes UInt64 max`() {
        let serializer = ASCII.Binary.Serializer<UInt64>()
        let codes = serializer.serialize(.max)
        #expect(codes == String(repeating: "1", count: 64).utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int8 min`() {
        let serializer = ASCII.Binary.Serializer<Int8>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-10000000".utf8.map(ASCII.Code.init))
    }
}
#endif
