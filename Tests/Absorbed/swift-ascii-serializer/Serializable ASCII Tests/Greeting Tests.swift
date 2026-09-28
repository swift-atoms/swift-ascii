#if Serializer
import Serializer
import ASCII
import Binary
import Testing

struct Greeting: Sendable {
    let codes: [ASCII.Code]
}

extension Greeting {
    struct Serializer: Sendable {
        @inlinable
        package init() {}
    }
}

extension Greeting.Serializer: Serializing {
    typealias Output = Greeting
    typealias Buffer = [ASCII.Code]
    typealias Failure = Never
    typealias Body = Never

    func serialize(_ output: Greeting, into buffer: inout [ASCII.Code]) {
        buffer.append(contentsOf: output.codes)
    }
}

extension Greeting: ASCII.Serializable {
    static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Greeting,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        buffer.append(contentsOf: value.codes)
    }
}

extension Greeting: Binary.Serializable {
    static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: borrowing Greeting,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: value.codes.map(\.byte))
    }
}

extension Greeting {
    @Suite struct `Greetings serialize through ASCII and Binary APIs` {
        @Suite struct `ASCII codes retain their byte values` {}
    }
}

extension Greeting.`Greetings serialize through ASCII and Binary APIs`.`ASCII codes retain their byte values` {
    @Test
    func `Serialization projects ASCII codes to bytes`() {
        let greeting = Greeting(codes: [0x4F, 0x4B])
        #expect(greeting.serialized == [0x4F, 0x4B].map(Byte.init(bitPattern:)))
    }

    @Test
    func `Appending a serialized value preserves the buffer prefix`() {
        var buffer: [Byte] = [Byte(bitPattern: 0x3E)]
        buffer.append(serialized: Greeting(codes: [0x4F, 0x4B]))
        #expect(buffer == [0x3E, 0x4F, 0x4B].map(Byte.init(bitPattern:)))
    }

    @Test
    func `Binary serialization preserves the ASCII bytes`() {
        let greeting = Greeting(codes: [0x4F, 0x4B])
        #expect([Byte](greeting) == [0x4F, 0x4B].map(Byte.init(bitPattern:)))
    }
}
#endif
