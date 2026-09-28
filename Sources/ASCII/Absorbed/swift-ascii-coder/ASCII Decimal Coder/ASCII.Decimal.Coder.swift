#if Coder
public import Byte
import Checkpoint
public import Coder
public import Cursor
public import Iterator
import Parser
import Serializer

extension ASCII.Decimal {

    public struct Coder<
        Input: Cursor.`Protocol`,
        Buffer: RangeReplaceableCollection,
        T: FixedWidthInteger
    >: Coding
    where
        Input.Element == Byte,
        Input.Failure == Never,
        Buffer.Element == Byte
    {
        public typealias Output = T

        public typealias Failure = ASCII.Decimal.Error

        public let parser: ASCII.Decimal.Parser<Input, T>

        @inlinable
        public init(
            sign: ASCII.Digits.Sign = .optional,
            count: ASCII.Digits.Count = .greedy
        ) {
            self.parser = .init(sign: sign, count: count)
        }

        @inlinable
        public borrowing func parse(_ input: inout Input) throws(Failure) -> T {
            try parser.parse(&input)
        }

        @inlinable
        public borrowing func serialize(_ output: borrowing T, into buffer: inout Buffer) throws(Failure) {

            let value = copy output

            let padding: Int
            var magnitude = value.magnitude
            var digits = 1
            while magnitude >= 10 {
                magnitude /= 10
                digits += 1
            }
            switch parser.count {
            case .greedy:
                padding = 0
            case .exactly(let count):
                guard count >= 0 else { throw .invalidCount(count) }
                guard count > 0 else { throw .insufficientDigits }
                guard digits <= count else { throw .overflow }
                padding = count - digits
            case .atMost(let count):
                guard count >= 0 else { throw .invalidCount(count) }
                guard count > 0 else { throw .noDigits }
                guard digits <= count else { throw .overflow }
                padding = 0
            }
            guard parser.sign == .optional || value >= 0 else {
                throw .invalidSign
            }
            if value < 0 {
                buffer.append(Byte(bitPattern: 0x2D))
            }
            for _ in 0..<padding {
                buffer.append(Byte(bitPattern: 0x30))
            }
            ASCII.Decimal.serialize(value.magnitude, into: &buffer)
        }
    }
}
#endif
