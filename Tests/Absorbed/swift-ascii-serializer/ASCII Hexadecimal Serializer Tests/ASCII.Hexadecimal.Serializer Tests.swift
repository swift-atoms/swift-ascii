#if Serializer
import Serializer
import ASCII
import Testing

@Suite
struct `ASCII.Hexadecimal.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `ASCII.Hexadecimal.Serializer Tests`.Unit {
    @Test
    func `serializes zero`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(0)
        #expect(codes == [ASCII.Code(0x30)])
    }

    @Test
    func `serializes single digit`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(0xA)
        #expect(codes == [ASCII.Code(0x61)])
    }

    @Test
    func `serializes multi-digit`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
        let codes = serializer.serialize(0xDEAD)
        #expect(codes == "dead".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes into existing buffer`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        var buffer: [ASCII.Code] = [ASCII.Code(0x41), ASCII.Code(0x42)]
        serializer.serialize(0xFF, into: &buffer)

        #expect(buffer == [ASCII.Code(0x41), ASCII.Code(0x42), ASCII.Code(0x66), ASCII.Code(0x66)])
    }

    @Test
    func `serializes negative`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int8>()
        let codes = serializer.serialize(-1)
        #expect(codes == [ASCII.Code(0x2D), ASCII.Code(0x31)])
    }

    @Test
    func `uses lowercase letters`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(0xAB)
        #expect(codes == "ab".utf8.map(ASCII.Code.init))
    }
}

extension `ASCII.Hexadecimal.Serializer Tests`.`Edge Case` {
    @Test
    func `serializes UInt8 max`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt8>()
        let codes = serializer.serialize(.max)
        #expect(codes == "ff".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes UInt64 max`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt64>()
        let codes = serializer.serialize(.max)
        #expect(codes == "ffffffffffffffff".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int64 min`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int64>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-8000000000000000".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes Int8 min`() {
        let serializer = ASCII.Hexadecimal.Serializer<Int8>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-80".utf8.map(ASCII.Code.init))
    }

    @Test
    func `serializes power of 16`() {
        let serializer = ASCII.Hexadecimal.Serializer<UInt32>()
        let codes = serializer.serialize(256)
        #expect(codes == "100".utf8.map(ASCII.Code.init))
    }
}
#endif
