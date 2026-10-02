#if Parser
public import Byte
import Checkpoint
public import Cursor
public import Iterator
public import Parser

extension ASCII.Octal {

    public struct Parser<Input: Cursor.`Protocol`, T: FixedWidthInteger>
    where Input.Element == Byte, Input.Failure == Never {

        public let sign: ASCII.Digits.Sign

        public let count: ASCII.Digits.Count

        @inlinable
        public init(sign: ASCII.Digits.Sign = .none, count: ASCII.Digits.Count = .greedy) {
            self.sign = sign
            self.count = count
        }
    }
}

extension ASCII.Octal.Parser: Parsing {

    public typealias Output = T

    public typealias Failure = ASCII.Octal.Error

    public typealias Body = Never

    public func parse(_ input: inout Input) throws(Failure) -> T {
        do throws(IntegerParsing.Error) {
            return try IntegerParsing.parse(&input, as: T.self, radix: .octal, sign: sign, count: count)
        } catch {
            switch error {
            case .noDigits: throw .noDigits
            case .overflow: throw .overflow
            case .insufficientDigits: throw .insufficientDigits
            case .invalidSign: throw .invalidSign
            case .invalidCount(let count): throw .invalidCount(count)
            }
        }
    }
}
#endif
