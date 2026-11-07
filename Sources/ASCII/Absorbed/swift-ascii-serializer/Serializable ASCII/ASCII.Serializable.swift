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

#if Serializer
    extension ASCII.Serializable {

        @inlinable
        public var asciiCodes: [ASCII.Code] {
            var buffer: [ASCII.Code] = []
            Self.serialize(self, into: &buffer)
            return buffer
        }

        @inlinable
        public var serialized: [Byte] {
            asciiCodes.map(\.byte)
        }
    }
#endif
