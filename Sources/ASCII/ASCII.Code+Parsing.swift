extension ASCII.Code {

    @inlinable
    public var digitValue: UInt8? {
        let byte = self.underlying
        guard ASCII.Classification.isDigit(byte) else { return nil }
        return byte - ASCII.Character.Graphic.`0`
    }

    @inlinable
    public var hexValue: UInt8? {
        let byte = self.underlying
        switch byte {
        case ASCII.Character.Graphic.`0`...ASCII.Character.Graphic.`9`:
            return byte - ASCII.Character.Graphic.`0`

        case ASCII.Character.Graphic.A...ASCII.Character.Graphic.F:
            return byte - ASCII.Character.Graphic.A + 10

        case ASCII.Character.Graphic.a...ASCII.Character.Graphic.f:
            return byte - ASCII.Character.Graphic.a + 10

        default:
            return nil
        }
    }
}
