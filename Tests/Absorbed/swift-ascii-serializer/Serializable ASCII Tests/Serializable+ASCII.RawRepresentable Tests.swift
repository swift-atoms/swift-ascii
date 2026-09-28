#if Serializer
import ASCII
import Testing

enum Command: String, ASCII.Serializable {
    case ok = "OK"
}

struct Frame: Swift.RawRepresentable, ASCII.Serializable {
    let rawValue: [Byte]
}

extension Command {
    @Suite struct `Raw values determine the ASCII representation` {
        @Suite struct `Serialization preserves the represented bytes` {}
    }
}

extension Command.`Raw values determine the ASCII representation`.`Serialization preserves the represented bytes` {
    @Test
    func `String raw values serialize as UTF8 bytes`() {
        #expect(Command.ok.serialized == [0x4F, 0x4B].map(Byte.init(bitPattern:)))
    }

    @Test
    func `String raw values serialize as ASCII codes`() {
        #expect(Command.ok.asciiCodes == [0x4F, 0x4B])
    }

    @Test
    func `The default output preserves the string raw value`() {
        let value = Command.ok

        let expected = value.rawValue.utf8.map { ASCII.Code($0) }
        #expect(value.asciiCodes == expected)
    }
}

extension Frame {
    @Suite struct `Raw values determine the ASCII representation` {
        @Suite struct `Serialization preserves the represented bytes` {}
    }
}

extension Frame.`Raw values determine the ASCII representation`.`Serialization preserves the represented bytes` {
    @Test
    func `Byte raw values serialize without changing their values`() {
        #expect(Frame(rawValue: [0x3E, 0x4F, 0x4B].map(Byte.init(bitPattern:))).serialized == [0x3E, 0x4F, 0x4B].map(Byte.init(bitPattern:)))
    }

    @Test
    func `Byte raw values serialize as ASCII codes`() {
        #expect(Frame(rawValue: [0x3E, 0x4F, 0x4B].map(Byte.init(bitPattern:))).asciiCodes == [0x3E, 0x4F, 0x4B])
    }

    @Test
    func `The default output preserves the byte raw value`() {
        let value = Frame(rawValue: [0x3E, 0x4F, 0x4B].map(Byte.init(bitPattern:)))

        let expected = value.rawValue.map { ASCII.Code(unchecked: $0) }
        #expect(value.asciiCodes == expected)
    }
}
#endif
