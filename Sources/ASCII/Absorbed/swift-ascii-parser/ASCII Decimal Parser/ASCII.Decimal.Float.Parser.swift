#if Parser
public import Byte
public import Checkpoint
public import Cursor
public import Iterator
public import Parser

extension ASCII.Decimal.Float {

    public struct Parser<Input: Cursor.`Protocol`>
    where Input.Element == Byte, Input.Failure == Never {

        @inlinable
        public init() {}
    }
}

extension ASCII.Decimal.Float.Parser: Parsing {

    public typealias Output = Double

    public typealias Failure = ASCII.Decimal.Float.Error

    public typealias Body = Never

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Double {
        let start = input.checkpoint
        var consumed = 0

        let signMark = input.checkpoint
        guard let firstByte = input.next() else {
            input.seek(to: signMark)
            throw .empty
        }

        var negative = false
        let first = firstByte.bitPattern
        if first == 0x2D {
            negative = true
            consumed += 1
        } else if first == 0x2B {
            consumed += 1
        } else {
            input.seek(to: signMark)
        }

        var mantissa: UInt64 = 0
        var nSignificantDigits = 0
        var nTotalDigits = 0
        var nDigitsAfterPoint = 0
        var tooManyDigits = false
        var sawAnyDigit = false

        while true {
            let mark = input.checkpoint
            guard let byte = input.next() else { break }
            let b = byte.bitPattern
            guard b >= 0x30, b <= 0x39 else {
                input.seek(to: mark)
                break
            }
            sawAnyDigit = true
            if nSignificantDigits < 19 {
                mantissa = mantissa &* 10 &+ UInt64(b &- 0x30)
                nSignificantDigits &+= 1
            } else {
                tooManyDigits = true
            }
            nTotalDigits &+= 1
            consumed += 1
        }

        let pointMark = input.checkpoint
        if let byte = input.next(), byte.bitPattern == 0x2E {
            consumed += 1
            while true {
                let mark = input.checkpoint
                guard let byte = input.next() else { break }
                let b = byte.bitPattern
                guard b >= 0x30, b <= 0x39 else {
                    input.seek(to: mark)
                    break
                }
                sawAnyDigit = true
                if nSignificantDigits < 19 {
                    mantissa = mantissa &* 10 &+ UInt64(b &- 0x30)
                    nSignificantDigits &+= 1
                } else {
                    tooManyDigits = true
                }
                nTotalDigits &+= 1
                nDigitsAfterPoint &+= 1
                consumed += 1
            }
        } else {
            input.seek(to: pointMark)
        }

        guard sawAnyDigit else {
            input.seek(to: start)
            throw .missingDigits
        }

        var explicitExp = 0
        let beforeExp = input.checkpoint
        let consumedBeforeExp = consumed
        if let marker = input.next(),
            marker.bitPattern == 0x65 || marker.bitPattern == 0x45
        {
            consumed += 1

            var expNegative = false
            let expSignMark = input.checkpoint
            if let s = input.next() {
                let code = s.bitPattern
                if code == 0x2D {
                    expNegative = true
                    consumed += 1
                } else if code == 0x2B {
                    consumed += 1
                } else {
                    input.seek(to: expSignMark)
                }
            } else {
                input.seek(to: expSignMark)
            }

            var expValue = 0
            var sawExpDigit = false
            while true {
                let mark = input.checkpoint
                guard let byte = input.next() else { break }
                let b = byte.bitPattern
                guard b >= 0x30, b <= 0x39 else {
                    input.seek(to: mark)
                    break
                }
                sawExpDigit = true

                if expValue < 100_000 {
                    expValue = expValue &* 10 &+ Int(b &- 0x30)
                }
                consumed += 1
            }

            if !sawExpDigit {
                input.seek(to: beforeExp)
                consumed = consumedBeforeExp
            } else {
                explicitExp = expNegative ? -expValue : expValue
            }
        } else {
            input.seek(to: beforeExp)
        }

        let q = explicitExp - nDigitsAfterPoint

        if !tooManyDigits,
            let fast = ASCII.Decimal.Float.clingerFastPath(
                negative: negative,
                mantissa: mantissa,
                q: q
            )
        {
            return fast
        } else if !tooManyDigits {
            return ASCII.Decimal.Float.eiselLemire(
                negative: negative,
                mantissa: mantissa,
                q: q
            )
        } else {
            let end = input.checkpoint
            input.seek(to: start)
            var bytes: [Byte] = []
            bytes.reserveCapacity(consumed)
            while bytes.count < consumed, let byte = input.next() {
                bytes.append(byte)
            }
            input.seek(to: end)
            _ = nTotalDigits
            return try ASCII.Decimal.Float.slowPath(bytes: bytes)
        }
    }
}

extension ASCII.Decimal.Float {

    @inlinable
    public static func parse(
        _ span: borrowing Swift.Span<Byte>
    ) throws(Self.Error) -> Double {
        guard !span.isEmpty else { throw .empty }

        var i = 0
        let end = span.count
        var negative = false

        let first = span[i].bitPattern
        if first == 0x2D {
            negative = true
            i &+= 1
        } else if first == 0x2B {
            i &+= 1
        }

        var mantissa: UInt64 = 0
        var nSignificantDigits = 0
        var nDigitsAfterPoint = 0
        var tooManyDigits = false
        var sawAnyDigit = false

        while i < end {
            let b = span[i].bitPattern
            guard b >= 0x30, b <= 0x39 else { break }
            sawAnyDigit = true
            if nSignificantDigits < 19 {
                mantissa = mantissa &* 10 &+ UInt64(b &- 0x30)
                nSignificantDigits &+= 1
            } else {
                tooManyDigits = true
            }
            i &+= 1
        }

        if i < end, span[i].bitPattern == 0x2E {
            i &+= 1
            while i < end {
                let b = span[i].bitPattern
                guard b >= 0x30, b <= 0x39 else { break }
                sawAnyDigit = true
                if nSignificantDigits < 19 {
                    mantissa = mantissa &* 10 &+ UInt64(b &- 0x30)
                    nSignificantDigits &+= 1
                } else {
                    tooManyDigits = true
                }
                nDigitsAfterPoint &+= 1
                i &+= 1
            }
        }

        guard sawAnyDigit else { throw .missingDigits }

        var explicitExp = 0
        let beforeExp = i
        if i < end {
            let b = span[i].bitPattern
            if b == 0x65 || b == 0x45 {
                i &+= 1
                var expNegative = false
                if i < end {
                    let s = span[i].bitPattern
                    if s == 0x2D {
                        expNegative = true
                        i &+= 1
                    } else if s == 0x2B {
                        i &+= 1
                    }
                }
                var expValue = 0
                var sawExpDigit = false
                while i < end {
                    let b = span[i].bitPattern
                    guard b >= 0x30, b <= 0x39 else { break }
                    sawExpDigit = true
                    if expValue < 100_000 {
                        expValue = expValue &* 10 &+ Int(b &- 0x30)
                    }
                    i &+= 1
                }
                if !sawExpDigit {
                    i = beforeExp
                } else {
                    explicitExp = expNegative ? -expValue : expValue
                }
            }
        }

        let q = explicitExp - nDigitsAfterPoint

        if !tooManyDigits,
            let fast = clingerFastPath(
                negative: negative,
                mantissa: mantissa,
                q: q
            )
        {
            return fast
        } else if !tooManyDigits {
            return eiselLemire(
                negative: negative,
                mantissa: mantissa,
                q: q
            )
        } else {

            var bytes: [UInt8] = []
            bytes.reserveCapacity(i)
            (0..<i).forEach { j in bytes.append(span[j].bitPattern) }
            let str = Swift.String(decoding: bytes, as: Swift.UTF8.self)
            return try slowPath(string: str)
        }
    }
}

extension ASCII.Decimal.Float {

    @usableFromInline
    internal static let maxMantissaFastPath: UInt64 = 9_007_199_254_740_991

    @usableFromInline
    internal static let minExponentFastPath: Int = -22
    @usableFromInline
    internal static let maxExponentFastPath: Int = 22

    @usableFromInline
    internal static let exactPowersOfTen: [Double] = [
        1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7,
        1e8, 1e9, 1e10, 1e11, 1e12, 1e13, 1e14, 1e15,
        1e16, 1e17, 1e18, 1e19, 1e20, 1e21, 1e22,
    ]

    @inlinable
    package static func clingerFastPath(
        negative: Bool,
        mantissa: UInt64,
        q: Int
    ) -> Double? {
        guard mantissa <= maxMantissaFastPath else { return nil }
        guard q >= minExponentFastPath, q <= maxExponentFastPath else { return nil }

        let m = Double(mantissa)
        let value: Double
        if q >= 0 {
            value = m * exactPowersOfTen[q]
        } else {
            value = m / exactPowersOfTen[-q]
        }
        return negative ? -value : value
    }
}

extension ASCII.Decimal.Float {
    @usableFromInline
    internal static let mantissaExplicitBits: Int = 52
    @usableFromInline
    internal static let minimumExponent: Int = -1023
    @usableFromInline
    internal static let infinitePower: Int = 0x7FF
    @usableFromInline
    internal static let minExponentRoundToEven: Int = -4
    @usableFromInline
    internal static let maxExponentRoundToEven: Int = 23

    @inlinable
    package static func eiselLemire(
        negative: Bool,
        mantissa: UInt64,
        q: Int
    ) -> Double {
        var w = mantissa

        if w == 0 || q < smallestPowerOfTen {
            return negative ? -0.0 : 0.0
        }
        if q > largestPowerOfTen {
            return negative ? -.infinity : .infinity
        }

        let lz = w.leadingZeroBitCount
        w <<= lz

        let tableIndex = q - smallestPowerOfTen
        let factor = powerOfFive128[tableIndex]

        var (high, low) = w.multipliedFullWidth(by: factor.high)

        let precisionMask: UInt64 = ~UInt64(0) >> (mantissaExplicitBits + 3)
        if (high & precisionMask) == precisionMask {
            let (h2, _) = w.multipliedFullWidth(by: factor.low)
            let newLow = low &+ h2
            if h2 > newLow {
                high &+= 1
            }
            low = newLow
        }

        let upperBit = Int(high >> 63)
        let shift = upperBit + 64 - mantissaExplicitBits - 3
        var resultMantissa = high >> shift

        let powerOfQ = (((152170 &+ 65536) &* q) >> 16) &+ 63
        var power2 = powerOfQ + upperBit - lz - minimumExponent

        if power2 <= 0 {
            if -power2 + 1 >= 64 {

                return negative ? -0.0 : 0.0
            }
            resultMantissa >>= UInt64(-power2 + 1)
            resultMantissa &+= resultMantissa & 1
            resultMantissa >>= 1

            let normalized = resultMantissa >= (UInt64(1) << mantissaExplicitBits)
            power2 = normalized ? 1 : 0
            return makeDouble(negative: negative, mantissa: resultMantissa, power2: power2)
        }

        if low <= 1,
            q >= minExponentRoundToEven, q <= maxExponentRoundToEven,
            (resultMantissa & 3) == 1
        {
            if (resultMantissa << shift) == high {
                resultMantissa &= ~UInt64(1)
            }
        }

        resultMantissa &+= resultMantissa & 1
        resultMantissa >>= 1

        if resultMantissa >= (UInt64(2) << mantissaExplicitBits) {
            resultMantissa = UInt64(1) << mantissaExplicitBits
            power2 &+= 1
        }

        resultMantissa &= ~(UInt64(1) << mantissaExplicitBits)

        if power2 >= infinitePower {
            return negative ? -.infinity : .infinity
        }

        return makeDouble(negative: negative, mantissa: resultMantissa, power2: power2)
    }

    @inlinable
    package static func makeDouble(
        negative: Bool,
        mantissa: UInt64,
        power2: Int
    ) -> Double {
        let signBit: UInt64 = negative ? (1 &<< 63) : 0
        let expBits: UInt64 = (UInt64(bitPattern: Int64(power2)) & 0x7FF) &<< 52
        let mantBits: UInt64 = mantissa & 0x000F_FFFF_FFFF_FFFF
        return Double(bitPattern: signBit | expBits | mantBits)
    }
}
#endif
