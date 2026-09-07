extension Swift.Character {

    public static var ascii: ASCII.Type {
        ASCII.self
    }

    public var ascii: ASCII {
        ASCII(character: self)
    }

    public struct ASCII {

        public let character: Character
    }
}

extension Swift.Character {

    @inlinable
    public init?(ascii byte: UInt8) {
        guard byte <= 0x7F else { return nil }
        self.init(UnicodeScalar(byte))
    }
}
