#if Serializer
    extension ASCII.Hexadecimal {

        public struct Serializer<T: FixedWidthInteger>: Sendable {

            @inlinable
            public init() {}
        }
    }

    extension ASCII.Hexadecimal.Serializer: Serializing {

        public typealias Output = T

        public typealias Buffer = [ASCII.Code]

        public typealias Failure = Never

        public typealias Body = Never

        @inlinable
        public func serialize(_ output: T, into buffer: inout [ASCII.Code]) {
            guard output != 0 else {
                buffer.append(ASCII.Code(0x30))
                return
            }

            let start = buffer.count

            var magnitude = output.magnitude
            while magnitude > 0 {
                buffer.append(Self._hexCode(UInt8(truncatingIfNeeded: magnitude & 0xF)))
                magnitude >>= 4
            }
            if output < 0 {
                buffer.append(ASCII.Code(0x2D))
            }

            var lo = start
            var hi = buffer.count &- 1
            while lo < hi {
                let tmp = buffer[lo]
                buffer[lo] = buffer[hi]
                buffer[hi] = tmp
                lo &+= 1
                hi &-= 1
            }
        }

        @inlinable
        package static func _hexCode(_ nibble: UInt8) -> ASCII.Code {
            ASCII.Code(nibble < 10 ? nibble &+ 0x30 : nibble &+ 0x57)
        }
    }
#endif
