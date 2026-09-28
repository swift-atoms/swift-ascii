#if Serializer
import Serializer
import ASCII
import Testing

@Suite
struct `Decimal serializers produce ASCII codes` {
    @Suite struct `Values serialize as decimal digits` {}
    @Suite struct `Integer boundaries serialize without narrowing` {}
    @Suite struct `Explicit serializers compose through their protocol` {}
}

extension `Decimal serializers produce ASCII codes`.`Values serialize as decimal digits` {
    @Test
    func `Zero serializes as one digit`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        let codes = serializer.serialize(0)
        #expect(codes == [ASCII.Code(0x30)])
    }

    @Test
    func `Single digit values serialize as one digit`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        let codes = serializer.serialize(7)
        #expect(codes == [ASCII.Code(0x37)])
    }

    @Test
    func `Multiple digits serialize in decimal order`() {
        let serializer = ASCII.Decimal.Serializer<UInt16>()
        let codes = serializer.serialize(8080)
        #expect(codes == [ASCII.Code(0x38), ASCII.Code(0x30), ASCII.Code(0x38), ASCII.Code(0x30)])
    }

    @Test
    func `Serialization preserves the existing buffer prefix`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        var buffer: [ASCII.Code] = [ASCII.Code(0x41), ASCII.Code(0x42)]
        serializer.serialize(42, into: &buffer)
        #expect(buffer == [ASCII.Code(0x41), ASCII.Code(0x42), ASCII.Code(0x34), ASCII.Code(0x32)])
    }

    @Test
    func `Negative values include a leading minus sign`() {
        let serializer = ASCII.Decimal.Serializer<Int8>()
        let codes = serializer.serialize(-1)
        #expect(codes == [ASCII.Code(0x2D), ASCII.Code(0x31)])
    }
}

extension `Decimal serializers produce ASCII codes`.`Integer boundaries serialize without narrowing` {
    @Test
    func `The largest UInt8 serializes without overflow`() {
        let serializer = ASCII.Decimal.Serializer<UInt8>()
        let codes = serializer.serialize(.max)
        #expect(codes == "255".utf8.map(ASCII.Code.init))
    }

    @Test
    func `The largest UInt64 serializes without overflow`() {
        let serializer = ASCII.Decimal.Serializer<UInt64>()
        let codes = serializer.serialize(.max)
        #expect(codes == "18446744073709551615".utf8.map(ASCII.Code.init))
    }

    @Test
    func `The smallest Int64 serializes without overflow`() {
        let serializer = ASCII.Decimal.Serializer<Int64>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-9223372036854775808".utf8.map(ASCII.Code.init))
    }

    @Test
    func `The smallest Int8 serializes without overflow`() {
        let serializer = ASCII.Decimal.Serializer<Int8>()
        let codes = serializer.serialize(.min)
        #expect(codes == "-128".utf8.map(ASCII.Code.init))
    }
}

extension `Decimal serializers produce ASCII codes`.`Explicit serializers compose through their protocol` {
    private func append<S: Serializing>(
        _ value: borrowing S.Output,
        using serializer: borrowing S,
        to buffer: inout [ASCII.Code]
    ) where S.Buffer == [ASCII.Code], S.Failure == Never {
        serializer.serialize(value, into: &buffer)
    }

    @Test(arguments: [Int128.min, -18_446_744_073_709_551_617, -1, 0, 1, Int128.max])
    func `Signed values retain every digit through the serializer protocol`(_ value: Int128) {
        var codes = [ASCII.Code(0x41)]
        append(value, using: ASCII.Decimal.Serializer<Int128>(), to: &codes)
        #expect(codes == [ASCII.Code(0x41)] + String(value).utf8.map(ASCII.Code.init))
    }

    @Test(arguments: [UInt128(0), 1, 18_446_744_073_709_551_616, UInt128.max])
    func `Unsigned values retain every digit through the serializer protocol`(_ value: UInt128) {
        var codes = [ASCII.Code(0x41)]
        append(value, using: ASCII.Decimal.Serializer<UInt128>(), to: &codes)
        #expect(codes == [ASCII.Code(0x41)] + String(value).utf8.map(ASCII.Code.init))
    }
}
#endif
