#if Parser
public import Byte
import Cursor

extension Swift.ArraySlice where Element == Byte {

    public static func bytes(_ values: UInt8...) -> ArraySlice<Byte> {
        values.map(Byte.init(bitPattern:))[...]
    }
}
#endif
