#if Serializer
extension ASCII.Decimal {

    public struct Serializer<T: FixedWidthInteger>: Sendable {

        @inlinable
        public init() {}
    }
}

extension ASCII.Decimal.Serializer: Serializing {
    public var body: Never {
        borrowing get {
            return fatalError("\(Self.self) is a leaf coder: implement parse and serialize directly")
        }
    }


    public typealias Output = T

    public typealias Buffer = [ASCII.Code]

    public typealias Failure = Never

    @inlinable
    public func serialize(_ output: borrowing T, into buffer: inout [ASCII.Code]) {
        ASCII.Decimal.serialize(output, into: &buffer)
    }
}
#endif
