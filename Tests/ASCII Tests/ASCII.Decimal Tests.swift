import ASCII
import Byte
import Testing

extension ASCII.Decimal {
    @Suite
    struct `Decimal serialization preserves full width integer values` {
        @Suite struct `No additional decimal serialization cases are defined` {}
        @Suite struct `Integer extremes serialize without overflow` {}
    }
}

extension ASCII.Decimal.`Decimal serialization preserves full width integer values`.`Integer extremes serialize without overflow` {

    @Test
    func
        `Serializing a UInt128 with twenty one digits does not overflow the buffer`()
    {

        let value: UInt128 = 100_000_000_000_000_000_000
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(value, into: &buffer)
        let expected = Array("100000000000000000000".utf8).map(Byte.init(bitPattern:))
        #expect(buffer == expected)
    }

    @Test
    func `Serializing the largest UInt128 writes all thirty nine decimal digits`() {
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(UInt128.max, into: &buffer)
        let expected = Array("340282366920938463463374607431768211455".utf8).map(Byte.init(bitPattern:))
        #expect(buffer == expected)
    }

    @Test
    func `Serializing the largest Int128 writes all thirty nine decimal digits`() {
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(Int128.max, into: &buffer)
        let expected = Array("170141183460469231731687303715884105727".utf8).map(Byte.init(bitPattern:))
        #expect(buffer == expected)
    }

    @Test
    func `Serializing the smallest Int128 writes its magnitude without trapping`() {
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(Int128.min, into: &buffer)
        let expected = Array("-170141183460469231731687303715884105728".utf8).map(Byte.init(bitPattern:))
        #expect(buffer == expected)
    }

    @Test
    func `Serializing the smallest Int8 does not trap`() {
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(Int8.min, into: &buffer)
        #expect(buffer == Array("-128".utf8).map(Byte.init(bitPattern:)))
    }

    @Test
    func `Serializing the smallest Int does not trap`() {
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(Int.min, into: &buffer)
        #expect(buffer == Array("-9223372036854775808".utf8).map(Byte.init(bitPattern:)))
    }

    @Test
    func `Serializing the smallest Int64 does not trap`() {
        var buffer: [Byte] = []
        ASCII.Decimal.serialize(Int64.min, into: &buffer)
        #expect(buffer == Array("-9223372036854775808".utf8).map(Byte.init(bitPattern:)))
    }
}

extension ASCII.Decimal.`Decimal serialization preserves full width integer values` {
    private func encoded<T: FixedWidthInteger>(_ value: T) -> (ContiguousArray<Byte>, ContiguousArray<ASCII.Code>) {
        var bytes: ContiguousArray<Byte> = [Byte(bitPattern: 0x41)]
        var codes: ContiguousArray<ASCII.Code> = [ASCII.Code(0x41)]
        ASCII.Decimal.serialize(value, into: &bytes)
        ASCII.Decimal.serialize(value, into: &codes)
        return (bytes, codes)
    }

    @Test(arguments: [Int128.min, -18_446_744_073_709_551_617, -1, 0, 1, Int128.max])
    func `Signed bytes and codes share decimal digits and preserve their prefixes`(_ value: Int128) {
        let (bytes, codes) = encoded(value)
        let expected = [UInt8(0x41)] + Array(String(value).utf8)
        #expect(bytes.map(\.bitPattern) == expected)
        #expect(codes.map(\.underlying) == expected)
    }

    @Test(arguments: [UInt128(0), 1, 18_446_744_073_709_551_616, UInt128.max])
    func `Unsigned bytes and codes share decimal digits and preserve their prefixes`(_ value: UInt128) {
        let (bytes, codes) = encoded(value)
        let expected = [UInt8(0x41)] + Array(String(value).utf8)
        #expect(bytes.map(\.bitPattern) == expected)
        #expect(codes.map(\.underlying) == expected)
    }
}
