extension ASCII {

    public static func normalized<C: Swift.Collection>(
        _ bytes: C,
        to lineEnding: ASCII.Line.Ending
    ) -> [UInt8] where C.Element == UInt8 {

        let cr = ASCII.Character.Control.cr
        let lf = ASCII.Character.Control.lf
        if !bytes.contains(where: { $0 == cr || $0 == lf }) {
            return Array(bytes)
        }

        let target: [UInt8] =
            switch lineEnding {
            case .lf: [lf]
            case .cr: [cr]
            case .crlf: [cr, lf]
            }

        var result = [UInt8]()
        result.reserveCapacity(bytes.count + (lineEnding == .crlf ? bytes.count / 10 : 0))

        var iterator = bytes.makeIterator()
        var lookahead: UInt8? = iterator.next()

        while let byte = lookahead {
            lookahead = iterator.next()

            if byte == cr {

                if lookahead == lf {

                    result.append(contentsOf: target)
                    lookahead = iterator.next()
                } else {

                    result.append(contentsOf: target)
                }
            } else if byte == lf {

                result.append(contentsOf: target)
            } else {

                result.append(byte)
            }
        }

        return result
    }
}
