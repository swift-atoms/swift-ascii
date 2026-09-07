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
