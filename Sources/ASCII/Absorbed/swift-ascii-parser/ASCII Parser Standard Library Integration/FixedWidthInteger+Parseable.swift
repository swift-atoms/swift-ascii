#if Parser
public import Byte
public import Cursor

extension Int: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, Int> { .init() }
}

extension UInt: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, UInt> { .init() }
}

extension Int8: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, Int8> { .init() }
}

extension Int16: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, Int16> { .init() }
}

extension Int32: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, Int32> { .init() }
}

extension Int64: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, Int64> { .init() }
}

extension UInt8: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, UInt8> { .init() }
}

extension UInt16: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, UInt16> { .init() }
}

extension UInt32: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, UInt32> { .init() }
}

extension UInt64: ASCII.Parseable {

    public static var parser: ASCII.Decimal.Parser<ArraySlice<Byte>, UInt64> { .init() }
}

extension FixedWidthInteger where Self: ASCII.Parseable {

    @inlinable
    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(ASCII.Decimal.Error)
    where Bytes.Element == Byte {
        var input = Swift.Array(bytes)[...]
        let leaf = ASCII.Decimal.Parser<ArraySlice<Byte>, Self>()
        self = try leaf.parse(&input)
    }
}
#endif
