#if Parser
import Byte
internal import Checkpoint
package import Cursor
internal import Iterator

package enum IntegerParsing {
    package enum Radix: Int { case binary = 2, octal = 8, decimal = 10, hexadecimal = 16 }
    package enum Error: Swift.Error {
        case noDigits, overflow, insufficientDigits, invalidSign
        case invalidCount(Int)
    }

    package static func parse<Input: Cursor.`Protocol`, T: FixedWidthInteger>(
        _ input: inout Input, as: T.Type, radix: Radix,
        sign: ASCII.Digits.Sign, count: ASCII.Digits.Count
    ) throws(Error) -> T where Input.Element == Byte, Input.Failure == Never {
        let limit: Int?
        switch count {
        case .greedy: limit = nil
        case .exactly(let n), .atMost(let n):
            guard n >= 0 else { throw .invalidCount(n) }
            limit = n
        }
        if case .exactly(0) = count { throw .insufficientDigits }
        let start = input.checkpoint
        var result: T = 0
        var consumed = 0
        var negative = false
        if sign == .optional {
            let mark = input.checkpoint
            if let byte = input.next() {
                switch byte.bitPattern {
                case 0x2B: break
                case 0x2D:
                    guard T.isSigned else {
                        input.seek(to: start)
                        throw .invalidSign
                    }
                    negative = true
                default: input.seek(to: mark)
                }
            } else { input.seek(to: mark) }
        }
        while true {
            if let limit, consumed == limit { break }
            let mark = input.checkpoint
            guard let byte = input.next() else { break }
            guard let digit = digit(byte.bitPattern), digit < radix.rawValue else {
                input.seek(to: mark)
                break
            }
            let (product, overflow) = result.multipliedReportingOverflow(by: T(radix.rawValue))
            guard !overflow else {
                input.seek(to: start)
                throw .overflow
            }
            let combined = negative
                ? product.subtractingReportingOverflow(T(digit))
                : product.addingReportingOverflow(T(digit))
            guard !combined.overflow else {
                input.seek(to: start)
                throw .overflow
            }
            result = combined.partialValue
            consumed += 1
        }
        switch count {
        case .exactly(let n):
            guard consumed == n else {
                input.seek(to: start)
                throw .insufficientDigits
            }
        case .greedy, .atMost:
            guard consumed > 0 else {
                input.seek(to: start)
                throw .noDigits
            }
        }
        return result
    }

    private static func digit(_ byte: UInt8) -> Int? {
        switch byte {
        case 0x30...0x39: Int(byte - 0x30)
        case 0x41...0x46: Int(byte - 0x37)
        case 0x61...0x66: Int(byte - 0x57)
        default: nil
        }
    }
}
#endif
