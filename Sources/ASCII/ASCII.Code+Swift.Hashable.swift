public import Byte

extension ASCII.Code: Swift.Hashable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(underlying)
    }
}
