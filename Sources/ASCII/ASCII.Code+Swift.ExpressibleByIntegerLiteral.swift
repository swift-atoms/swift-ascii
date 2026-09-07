public import Byte

extension ASCII.Code: Swift.ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: UInt8.IntegerLiteralType) {
        let u = UInt8(integerLiteral: value)
        precondition(
            u < 0x80,
            "ASCII.Code integer literal must be in 0x00...0x7F (got 0x\(String(u, radix: 16)))"
        )
        self.init(unchecked: Byte(bitPattern: u))
    }
}
