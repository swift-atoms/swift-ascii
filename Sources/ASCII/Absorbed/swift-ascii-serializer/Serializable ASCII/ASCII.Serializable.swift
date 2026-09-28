#if Serializer
extension ASCII {

    public protocol Serializable {

        static func serialize<Buffer: RangeReplaceableCollection>(
            _ serializable: borrowing Self,
            into buffer: inout Buffer
        ) where Buffer.Element == ASCII.Code
    }
}
#endif
