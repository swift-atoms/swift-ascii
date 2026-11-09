#if Serializer
    extension ASCII.Octal {

        public struct Serializer<T: FixedWidthInteger>: Sendable {

            @inlinable
            public init() {}
        }
    }

    extension ASCII.Octal.Serializer: Serializing {

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
                buffer.append(ASCII.Code(UInt8(truncatingIfNeeded: magnitude % 8) &+ 0x30))
                magnitude /= 8
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
    }
#endif
