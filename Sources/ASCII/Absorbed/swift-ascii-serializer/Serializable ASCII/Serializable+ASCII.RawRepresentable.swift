#if Serializer
extension ASCII.Serializable
where
    Self: Swift.RawRepresentable,
    Self.RawValue == String
{

    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {

        for byte in value.rawValue.utf8 {
            buffer.append(ASCII.Code(byte))
        }
    }
}

extension ASCII.Serializable
where
    Self: Swift.RawRepresentable,
    Self.RawValue == [Byte]
{

    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {

        for byte in value.rawValue {
            buffer.append(ASCII.Code(unchecked: byte))
        }
    }
}
#endif
