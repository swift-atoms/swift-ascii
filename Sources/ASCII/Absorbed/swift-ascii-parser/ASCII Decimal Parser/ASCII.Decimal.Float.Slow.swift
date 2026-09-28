#if Parser
public import Byte

extension ASCII.Decimal.Float {

    @inlinable
    package static func slowPath(bytes: [Byte]) throws(Self.Error) -> Double {
        var raw: [UInt8] = []
        raw.reserveCapacity(bytes.count)
        for byte in bytes {
            raw.append(byte.bitPattern)
        }
        let string = Swift.String(decoding: raw, as: Swift.UTF8.self)
        return try slowPath(string: string)
    }

    @inlinable
    package static func slowPath(string: Swift.String) throws(Self.Error) -> Double {

        guard let value = Swift.Double(string) else {
            throw .overflow
        }
        return value
    }
}
#endif
