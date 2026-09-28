#if Parser
import Byte
import ASCII
import Testing

@Suite
struct `Parseable Integer Tests` {

    @Test
    func `Int parses via Parseable`() throws {
        let value = try Int(ascii: "42".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 42)
    }

    @Test
    func `UInt parses via Parseable`() throws {
        let value = try UInt(ascii: "100".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 100)
    }

    @Test
    func `Int8 parses via Parseable`() throws {
        let value = try Int8(ascii: "127".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 127)
    }

    @Test
    func `UInt8 parses via Parseable`() throws {
        let value = try UInt8(ascii: "255".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 255)
    }

    @Test
    func `Int16 parses via Parseable`() throws {
        let value = try Int16(ascii: "8080".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 8080)
    }

    @Test
    func `UInt16 parses via Parseable`() throws {
        let value = try UInt16(ascii: "65535".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 65535)
    }

    @Test
    func `Int32 parses via Parseable`() throws {
        let value = try Int32(ascii: "0".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 0)
    }

    @Test
    func `UInt32 parses via Parseable`() throws {
        let value = try UInt32(ascii: "1000000".utf8.map(Byte.init(bitPattern:)))
        #expect(value == 1_000_000)
    }

    @Test
    func `Int64 parses via Parseable`() throws {
        let value = try Int64(ascii: "9223372036854775807".utf8.map(Byte.init(bitPattern:)))
        #expect(value == Int64.max)
    }

    @Test
    func `UInt64 parses via Parseable`() throws {
        let value = try UInt64(ascii: "18446744073709551615".utf8.map(Byte.init(bitPattern:)))
        #expect(value == UInt64.max)
    }
}


extension `Parseable Integer Tests` {
    @Test func acceptsLazyAndNonzeroStartCollections() throws {
        let lazyBytes = "42".utf8.lazy.map(Byte.init(bitPattern:))
        #expect(try Int(ascii: lazyBytes) == 42)
        let storage = [Byte](utf8: "xx42")
        let slice = storage.dropFirst(2)
        #expect(try Int(ascii: slice) == 42)
        #expect(slice.startIndex == 2)
        #expect(slice.map(\.bitPattern) == Array("42".utf8))
    }
}
#endif
