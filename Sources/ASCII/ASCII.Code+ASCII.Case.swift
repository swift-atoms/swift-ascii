extension ASCII.Code {
    @inlinable
    public func callAsFunction(case: Swift.Character.Case) -> UInt8 {
        ASCII.Case.Conversion.convert(self, to: `case`).underlying
    }
}
