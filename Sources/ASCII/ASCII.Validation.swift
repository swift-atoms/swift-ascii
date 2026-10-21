extension ASCII {

    public enum Validation {}
}

extension ASCII.Validation {

    @_transparent
    public static func isASCII(_ byte: UInt8) -> Bool {
        byte <= 0x7F
    }

    @inlinable
    public static func isAllASCII<C: Swift.Collection>(
        _ bytes: C
    ) -> Bool where C.Element == UInt8 {

        if let result = bytes.withContiguousStorageIfAvailable({ unsafe _isAllASCIIFast($0) }) {
            return result
        }

        return bytes.allSatisfy { Self.isASCII($0) }
    }

    @usableFromInline
    internal static func _isAllASCIIFast(_ buffer: UnsafeBufferPointer<UInt8>) -> Bool {
        guard let base = buffer.baseAddress else { return true }
        let count = buffer.count

        var i = 0

        let highBitMask: UInt64 = 0x8080_8080_8080_8080
        while i + 8 <= count {
            let chunk = unsafe base.advanced(by: i).withMemoryRebound(to: UInt64.self, capacity: 1) { unsafe $0.pointee }
            if chunk & highBitMask != 0 {
                return false
            }
            i += 8
        }

        while i < count {
            if unsafe base[i] > 0x7F {
                return false
            }
            i += 1
        }

        return true
    }
}

extension ASCII {

    @_transparent
    public static func isASCII(_ byte: UInt8) -> Bool {
        Validation.isASCII(byte)
    }

    @inlinable
    public static func isAllASCII<C: Swift.Collection>(
        _ bytes: C
    ) -> Bool where C.Element == UInt8 {
        Validation.isAllASCII(bytes)
    }
}
