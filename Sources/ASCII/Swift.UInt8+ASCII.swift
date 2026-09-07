extension Swift.UInt8 {

    public static var ascii: ASCII.Code.Type {
        ASCII.Code.self
    }

    public var ascii: ASCII.Code {
        ASCII.Code(self)
    }
}

extension Swift.UInt8 {

    @inline(always)
    public init?(ascii character: Character) {
        guard let value = character.asciiValue else { return nil }
        self = value
    }
}
