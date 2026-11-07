import ASCII
import Carrier
import Testing

@Suite
struct `ASCII Carrier` {

    @Test
    func `ASCII.Code carries its byte`() {
        let code = ASCII.Code(0x41)

        #expect(underlying(of: code) == 0x41)
    }

    @Test
    func `ASCII constants project into any byte carrier`() {
        let values: [Byte] = [
            Byte.ascii.nul,
            Byte.ascii.space,
            Byte.ascii.`0`,
            Byte.ascii.A,
            Byte.ascii.z,
            Byte.ascii.tilde,
            Byte.ascii.del,
        ]

        #expect(values.map(\.underlying) == [0x00, 0x20, 0x30, 0x41, 0x7A, 0x7E, 0x7F])
    }

    @Test
    func `Projected names preserve ASCII aliases`() {
        #expect(Byte.ascii.htab == Byte.ascii.tab)
        #expect(Byte.ascii.lf == Byte.ascii.newline)
        #expect(Byte.ascii.exclamationPoint == Byte.ascii.exclamationMark)
        #expect(Byte.ascii.underline == Byte.ascii.underscore)
        #expect(Byte.ascii.underscore == Byte.ascii.lowLine)
        #expect(Byte.ascii.leftBrace == Byte.ascii.leftCurlyBracket)
        #expect(Byte.ascii.rightBrace == Byte.ascii.rightCurlyBracket)
    }

    @Test
    func `Projected values are sourced from ASCII.Code`() {
        #expect(Byte.ascii.exclamationMark.underlying == ASCII.Code.exclamationMark.underlying)
        #expect(Byte.ascii.circumflex.underlying == ASCII.Code.circumflex.underlying)
        #expect(Byte.ascii.graveAccent.underlying == ASCII.Code.graveAccent.underlying)
        #expect(Byte.ascii.backtick.underlying == ASCII.Code.backtick.underlying)
    }
}

private struct Byte: Carrier.`Protocol`, Equatable {

    let underlying: UInt8

    init(_ underlying: consuming UInt8) {
        self.underlying = underlying
    }
}

private func underlying<C: Carrier.`Protocol`>(of carrier: borrowing C) -> UInt8
where C.Underlying == UInt8 {
    carrier.underlying
}
