public import Byte

extension Swift.StringProtocol {
    public static func normalized<S: StringProtocol>(
        _ string: S,
        to lineEnding: ASCII::ASCII.Line.Ending
    ) -> S {
        .init(
            decoding: ASCII::ASCII.normalized(string.utf8, to: lineEnding),
            as: UTF8.self
        )
    }

    public func normalized(to lineEnding: ASCII::ASCII.Line.Ending) -> Self {
        Self.normalized(self, to: lineEnding)
    }

    public init(ascii lineEnding: ASCII::ASCII.Line.Ending) {
        let bytes: [UInt8] = switch lineEnding {
        case .lf: [ASCII::ASCII.Character.Control.lf]
        case .cr: [ASCII::ASCII.Character.Control.cr]
        case .crlf: [ASCII::ASCII.Character.Control.cr, ASCII::ASCII.Character.Control.lf]
        }
        self.init(decoding: bytes, as: UTF8.self)
    }

    public init?(ascii bytes: [Byte]) {
        guard bytes.allSatisfy({ $0.bitPattern < 0x80 }) else { return nil }
        self.init(decoding: bytes.lazy.map(\.bitPattern), as: UTF8.self)
    }

    @inlinable
    public init<Codes: Sequence>(ascii codes: Codes)
    where Codes.Element == ASCII::ASCII.Code {
        self.init(decoding: codes.lazy.map(\.underlying), as: UTF8.self)
    }

    public init?(ascii byte: Byte) {
        guard byte.bitPattern < 0x80 else { return nil }
        self.init(decoding: CollectionOfOne(byte.bitPattern), as: UTF8.self)
    }
}
