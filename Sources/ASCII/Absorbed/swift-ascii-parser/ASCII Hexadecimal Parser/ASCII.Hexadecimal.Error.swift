#if Parser
extension ASCII.Hexadecimal {

    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidCount(Int)

        case noDigits

        case overflow

        case insufficientDigits

        case invalidSign
    }
}
#endif
