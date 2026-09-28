#if Serializer
extension RangeReplaceableCollection where Element == Byte {

    @inlinable
    public mutating func append<Value: ASCII.Serializable>(serialized value: Value) {
        self.append(contentsOf: value.serialized)
    }
}
#endif
