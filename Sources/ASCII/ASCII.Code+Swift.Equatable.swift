import Byte

extension ASCII.Code: Swift.Equatable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.underlying == rhs.underlying
    }
}
