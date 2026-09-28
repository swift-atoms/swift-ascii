#if Serializer
import ASCII
import Binary
import Testing

private struct Token: Sendable, Codable {
    let rawValue: String

    internal init(
        __unchecked: Void,
        rawValue: String
    ) {
        self.rawValue = rawValue
    }

    public init(
        _ value: String
    ) throws(Error) {
        let bytes: [Byte] = [Byte](utf8: value)
        guard !bytes.isEmpty else { throw .empty }

        for byte in bytes {
            guard byte.bitPattern.ascii.isAlphanumeric || byte == ASCII.Code.hyphen.byte else {
                throw .invalidCharacter(byte)
            }
        }

        self.init(
            __unchecked: (),
            rawValue: value
        )
    }
}

extension Token {
    enum Error: Swift.Error, Sendable, Equatable {
        case empty
        case invalidCharacter(Byte)
    }
}

extension Token: Binary.Serializable {
    static func serialize<Buffer>(_ token: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {
        buffer.append(contentsOf: token.rawValue.utf8.map(Byte.init(bitPattern:)))
    }
}

extension Token {

    init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        try self.init(String(decoding: bytes, as: UTF8.self))
    }
}

extension Token: Hashable {}
extension Token: CustomStringConvertible {
    var description: String { String(self) }
}
extension Token: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {

        self.init(__unchecked: (), rawValue: value)
    }
}

private struct DelimitedMessage: Sendable, Codable {
    let parts: [String]
    let delimiter: Byte

    init(__unchecked: Void, parts: [String], delimiter: Byte) {
        self.parts = parts
        self.delimiter = delimiter
    }
}

extension DelimitedMessage {
    private enum CodingKeys: String, CodingKey { case parts, delimiter }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parts = try container.decode([String].self, forKey: .parts)
        delimiter = Byte(bitPattern: try container.decode(UInt8.self, forKey: .delimiter))
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parts, forKey: .parts)
        try container.encode(delimiter.bitPattern, forKey: .delimiter)
    }
}

extension DelimitedMessage: Binary.Serializable {
    enum Error: Swift.Error, Sendable, Equatable {
        case empty
    }

    static func serialize<Buffer>(_ message: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {
        for (index, part) in message.parts.enumerated() {
            if index > 0 {

                buffer.append(message.delimiter)
            }
            buffer.append(contentsOf: part.utf8.map(Byte.init(bitPattern:)))
        }
    }
}

extension DelimitedMessage {

    init<Bytes: Swift.Collection>(ascii bytes: Bytes, delimiter: Byte) throws(Error)
    where Bytes.Element == Byte {
        guard !bytes.isEmpty else { throw .empty }

        var parts: [String] = []
        var current: [Byte] = []

        for byte in bytes {

            if byte == delimiter {
                parts.append(String(decoding: current, as: UTF8.self))
                current = []
            } else {
                current.append(byte)
            }
        }

        parts.append(String(decoding: current, as: UTF8.self))

        self.init(__unchecked: (), parts: parts, delimiter: delimiter)
    }
}

extension DelimitedMessage: Hashable {}
extension DelimitedMessage: CustomStringConvertible {
    var description: String { String(self) }
}

extension Token {
    @Suite
    struct `Nominal values preserve their ASCII representation` {
        @Test
        func `ASCII bytes initialize a token`() throws {
            let bytes: [Byte] = "hello-world".utf8.map(Byte.init(bitPattern:))
            let token: Token = try .init(ascii: bytes)

            #expect(token.rawValue == "hello-world")
        }

        @Test
        func `An ASCII string initializes a token`() throws {
            let token: Token = try .init("my-token")

            #expect(token.rawValue == "my-token")
        }

        @Test
        func `A string literal initializes a token`() {
            let token: Token = "literal-token"

            #expect(token.rawValue == "literal-token")
        }

        @Test
        func `Nominal values serialize to their ASCII bytes`() throws {
            let token: Token = try .init("hello")

            let serialized: [Byte] = Token.serialize(token)
            #expect(serialized == "hello".utf8.map(Byte.init(bitPattern:)))
        }

        @Test
        func `A token converts to its ASCII string`() throws {
            let token: Token = try .init("world")

            #expect(String(token) == "world")
        }

        @Test
        func `Token bytes survive a round trip`() throws {
            let original: [Byte] = "round-trip".utf8.map(Byte.init(bitPattern:))
            let token: Token = try .init(ascii: original)

            let serialized: [Byte] = token.bytes
            #expect(serialized == original)
        }

        @Test
        func `Token strings survive a round trip`() throws {
            let original = "test-value"
            let token: Token = try .init(original)
            let result = String(token)

            #expect(result == original)
        }

        @Test
        func `Invalid token input throws its declared error`() {
            let bytes: [Byte] = "hello world".utf8.map(Byte.init(bitPattern:))

            #expect(throws: Token.Error.self) {
                try Token(ascii: bytes)
            }
        }

        @Test
        func `Empty input throws its declared error`() {
            let bytes: [Byte] = []

            #expect(throws: Token.Error.empty) {
                try Token(ascii: bytes)
            }
        }
    }
}

extension DelimitedMessage {
    @Suite
    struct `Nominal values preserve their ASCII representation` {
        @Test
        func `An explicit delimiter separates the message parts`() throws {
            let bytes: [Byte] = "foo|bar|baz".utf8.map(Byte.init(bitPattern:))

            let message = try DelimitedMessage(ascii: bytes, delimiter: ASCII.Code.verticalLine.byte)

            #expect(message.parts == ["foo", "bar", "baz"])
            #expect(message.delimiter == ASCII.Code.verticalLine.byte)
        }

        @Test
        func `Different delimiters produce different parses`() throws {
            let bytes: [Byte] = "a,b|c".utf8.map(Byte.init(bitPattern:))

            let commaMessage = try DelimitedMessage(ascii: bytes, delimiter: ASCII.Code.comma.byte)
            #expect(commaMessage.parts == ["a", "b|c"])

            let pipeMessage = try DelimitedMessage(ascii: bytes, delimiter: ASCII.Code.verticalLine.byte)
            #expect(pipeMessage.parts == ["a,b", "c"])
        }

        @Test
        func `Nominal values serialize to their ASCII bytes`() throws {
            let message = DelimitedMessage(
                __unchecked: (),
                parts: ["hello", "world"],
                delimiter: ASCII.Code.hyphen.byte
            )

            let serialized: [Byte] = DelimitedMessage.serialize(message)
            #expect(serialized == "hello-world".utf8.map(Byte.init(bitPattern:)))
        }

        @Test
        func `Message bytes survive a round trip`() throws {
            let original: [Byte] = "one:two:three".utf8.map(Byte.init(bitPattern:))

            let message = try DelimitedMessage(ascii: original, delimiter: ASCII.Code.colon.byte)

            let serialized: [Byte] = message.bytes
            #expect(serialized == original)
        }

        @Test
        func `A message serializes to its delimited string`() throws {
            let message = DelimitedMessage(
                __unchecked: (),
                parts: ["a", "b", "c"],
                delimiter: ASCII.Code.semicolon.byte
            )

            let string = String(message)

            #expect(string == "a;b;c")
        }

        @Test
        func `Empty input throws its declared error`() {
            let bytes: [Byte] = []

            #expect(throws: DelimitedMessage.Error.empty) {
                try DelimitedMessage(ascii: bytes, delimiter: ASCII.Code.comma.byte)
            }
        }

        @Test
        func `Message construction accepts an explicit delimiter`() {

            let bytes: [Byte] = "a,b,c".utf8.map(Byte.init(bitPattern:))
            let message = try? DelimitedMessage(ascii: bytes, delimiter: ASCII.Code.comma.byte)

            #expect(message != nil)
        }
    }
}

@Suite
struct `Values determine their own binary representation` {
    @Test
    func `The message value determines its serialized delimiter`() throws {

        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["x", "y"],
            delimiter: ASCII.Code.comma.byte
        )

        let serialized: [Byte] = DelimitedMessage.serialize(message)
        #expect(serialized == "x,y".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `Valid token bytes survive parsing and serialization`() throws {

        let original: [Byte] = "valid-token".utf8.map(Byte.init(bitPattern:))

        let token: Token = try .init(ascii: original)
        let serialized: [Byte] = token.bytes
        #expect(serialized == original)
    }
}

private struct HTMLAnchor: Binary.Serializable {
    let href: Token
    let text: String
}

extension HTMLAnchor {
    static func serialize<Buffer>(_ anchor: Self, into buffer: inout Buffer)
    where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {
        buffer.append(contentsOf: "<a href=\"".utf8.map(Byte.init(bitPattern:)))
        Token.serialize(anchor.href, into: &buffer)
        buffer.append(contentsOf: "\">".utf8.map(Byte.init(bitPattern:)))
        buffer.append(contentsOf: anchor.text.utf8.map(Byte.init(bitPattern:)))
        buffer.append(contentsOf: "</a>".utf8.map(Byte.init(bitPattern:)))
    }
}

@Suite
struct `Nominal types serialize through explicit binary conformances` {

    @Test
    func `Tokens serialize through their binary conformance`() throws {
        let token: Token = try .init("my-token")

        var buffer: [Byte] = []
        token.serialize(into: &buffer)

        #expect(buffer == "my-token".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `Delimited messages serialize through their binary conformance`() {
        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["a", "b", "c"],
            delimiter: ASCII.Code.comma.byte
        )

        var buffer: [Byte] = []
        message.serialize(into: &buffer)

        #expect(buffer == "a,b,c".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `A token writes its representation into a buffer`() throws {
        let token: Token = try .init("hello-world")

        var buffer: [Byte] = []
        token.serialize(into: &buffer)

        #expect(buffer == "hello-world".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `The bytes property returns the token representation`() throws {
        let token: Token = try .init("swift-token")

        let bytes: [Byte] = token.bytes

        #expect(bytes == "swift-token".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `Serialization preserves the existing buffer content`() throws {
        let token: Token = try .init("suffix")

        var buffer: [Byte] = "prefix-".utf8.map(Byte.init(bitPattern:))
        token.serialize(into: &buffer)

        #expect(buffer == "prefix-suffix".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `ASCII values compose inside a containing serializer`() throws {
        let anchor = try HTMLAnchor(
            href: .init("example-link"),
            text: "Click here"
        )

        let result = String(anchor)

        #expect(result == "<a href=\"example-link\">Click here</a>")
    }

    @Test
    func `Multiple ASCII values serialize into a shared buffer`() throws {
        let token1: Token = try .init("first")
        let token2: Token = try .init("second")
        let message = DelimitedMessage(
            __unchecked: (),
            parts: ["a", "b"],
            delimiter: ASCII.Code.colon.byte
        )

        var buffer: [Byte] = []
        token1.serialize(into: &buffer)
        buffer.append(ASCII.Code.hyphen.byte)
        token2.serialize(into: &buffer)
        buffer.append(ASCII.Code.verticalLine.byte)
        message.serialize(into: &buffer)

        #expect(buffer == "first-second|a:b".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `Serialization preserves ordering in a reserved buffer`() throws {
        let tokens = try (1...10).map { try Token("token-\($0)") }

        var buffer: [Byte] = []
        buffer.reserveCapacity(200)

        for (index, token) in tokens.enumerated() {
            if index > 0 {
                buffer.append(ASCII.Code.comma.byte)
            }
            token.serialize(into: &buffer)
        }

        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result.hasPrefix("token-1,token-2"))
        #expect(result.hasSuffix("token-10"))
    }

    @Test
    func `Buffer and convenience serialization produce the same bytes`() throws {
        let token: Token = try .init("roundtrip-test")

        let staticBytes: [Byte] = Token.serialize(token)

        var streamingBuffer: [Byte] = []
        token.serialize(into: &streamingBuffer)

        let propertyBytes: [Byte] = token.bytes

        #expect(staticBytes == streamingBuffer)
        #expect(staticBytes == propertyBytes)
    }
}

@Suite
struct `Binary serializers compose through shared buffers` {

    @Test
    func `A response buffer combines literal bytes and serialized values`() throws {

        var response: [Byte] = []

        response.append(contentsOf: "X-Token: ".utf8.map(Byte.init(bitPattern:)))
        let token: Token = try .init("auth-token-123")
        token.serialize(into: &response)
        response.append(contentsOf: "\r\n".utf8.map(Byte.init(bitPattern:)))

        let result = String(decoding: response, as: UTF8.self)
        #expect(result == "X-Token: auth-token-123\r\n")
    }

    @Test
    func `An HTML anchor embeds its serialized token`() throws {
        let anchor = try HTMLAnchor(
            href: .init("https-link"),
            text: "Visit site"
        )

        let bytes: [Byte] = anchor.bytes

        let string = String(anchor)

        #expect(bytes == string.utf8.map(Byte.init(bitPattern:)))
        #expect(string == "<a href=\"https-link\">Visit site</a>")
    }

    @Test
    func `A reusable buffer preserves each serialized result`() throws {
        var buffer: [Byte] = []
        var results: [[Byte]] = []

        let inputs = ["alpha", "beta", "gamma"]

        for input in inputs {
            buffer.removeAll(keepingCapacity: true)
            let token: Token = try .init(input)
            token.serialize(into: &buffer)
            results.append(buffer)
        }

        #expect(results.count == 3)
        #expect(results[0] == "alpha".utf8.map(Byte.init(bitPattern:)))
        #expect(results[1] == "beta".utf8.map(Byte.init(bitPattern:)))
        #expect(results[2] == "gamma".utf8.map(Byte.init(bitPattern:)))
    }

    @Test
    func `A containing serializer composes nested ASCII values`() throws {

        struct Document: Binary.Serializable {
            let title: Token
            let links: [HTMLAnchor]

            static func serialize<Buffer>(_ doc: Self, into buffer: inout Buffer)
            where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {
                buffer.append(contentsOf: "<html><head><title>".utf8.map(Byte.init(bitPattern:)))
                Token.serialize(doc.title, into: &buffer)
                buffer.append(contentsOf: "</title></head><body>".utf8.map(Byte.init(bitPattern:)))
                for link in doc.links {
                    link.serialize(into: &buffer)
                }
                buffer.append(contentsOf: "</body></html>".utf8.map(Byte.init(bitPattern:)))
            }
        }

        let doc = try Document(
            title: .init("My-Page"),
            links: [
                HTMLAnchor(href: .init("link1"), text: "First"),
                HTMLAnchor(href: .init("link2"), text: "Second"),
            ]
        )

        let html = String(doc)

        #expect(html.contains("<title>My-Page</title>"))
        #expect(html.contains("<a href=\"link1\">First</a>"))
        #expect(html.contains("<a href=\"link2\">Second</a>"))
    }
}

private struct CorrectEmailAddress: Sendable, Codable, Hashable {
    let localPart: String
    let domain: String

    init(__unchecked: Void, localPart: String, domain: String) {
        self.localPart = localPart
        self.domain = domain
    }
}

extension CorrectEmailAddress: Binary.Serializable {
    enum Error: Swift.Error, Sendable, Equatable {
        case empty
        case missingAtSign
    }

    static func serialize<Buffer: RangeReplaceableCollection>(
        _ email: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: email.localPart.utf8.map(Byte.init(bitPattern:)))
        buffer.append(ASCII.Code.commercialAt.byte)
        buffer.append(contentsOf: email.domain.utf8.map(Byte.init(bitPattern:)))
    }
}

extension CorrectEmailAddress {

    init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard !bytes.isEmpty else { throw .empty }

        let byteArray: [Byte] = Array(bytes)
        guard let atIndex = byteArray.firstIndex(of: ASCII.Code.commercialAt.byte) else {
            throw .missingAtSign
        }

        self.init(
            __unchecked: (),
            localPart: String(decoding: byteArray[..<atIndex], as: UTF8.self),
            domain: String(decoding: byteArray[byteArray.index(after: atIndex)...], as: UTF8.self)
        )
    }

    init(_ value: String) throws(Error) {
        try self.init(ascii: value.utf8.map(Byte.init(bitPattern:)))
    }
}

extension CorrectEmailAddress: Swift.RawRepresentable {

    var rawValue: String { String(self) }

    init?(rawValue: String) {
        try? self.init(rawValue)
    }
}

extension CorrectEmailAddress: CustomStringConvertible {
    var description: String { String(self) }
}

extension CorrectEmailAddress {
    @Suite
    struct `Nominal values preserve their ASCII representation` {

        @Test
        func `Derived representations avoid recursive serialization`() throws {
            let email = try CorrectEmailAddress("user@example.com")

            let rawValue = email.rawValue
            let description = email.description
            let bytes: [Byte] = email.bytes

            #expect(rawValue == "user@example.com")
            #expect(description == "user@example.com")
            #expect(bytes == "user@example.com".utf8.map(Byte.init(bitPattern:)))
        }

        @Test
        func `The raw value is derived from serialization`() throws {
            let email = try CorrectEmailAddress("test@domain.org")

            #expect(email.rawValue == "test@domain.org")
        }

        @Test
        func `An email value survives a raw value round trip`() throws {
            let original = try CorrectEmailAddress("hello@world.net")

            let rawValue = original.rawValue
            let restored = try CorrectEmailAddress(rawValue)

            #expect(original == restored)
        }

        @Test
        func `Direct serialization does not access the derived raw value`() throws {
            let email = try CorrectEmailAddress("direct@serialize.test")

            var buffer: [Byte] = []
            CorrectEmailAddress.serialize(email, into: &buffer)

            #expect(buffer == "direct@serialize.test".utf8.map(Byte.init(bitPattern:)))
        }

        @Test
        func `Every email representation preserves the same ASCII bytes`() throws {

            let email = try CorrectEmailAddress("checklist@test.com")

            #expect(email.rawValue == "checklist@test.com")
            #expect(email.description == "checklist@test.com")
            #expect(String(email) == "checklist@test.com")
            let bytes: [Byte] = email.bytes
            #expect(bytes == "checklist@test.com".utf8.map(Byte.init(bitPattern:)))

            var buffer: [Byte] = []
            email.serialize(into: &buffer)
            #expect(buffer == "checklist@test.com".utf8.map(Byte.init(bitPattern:)))
        }
    }
}
#endif
