#if Parser
extension ASCII.Decimal.Float {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case missingDigits

        case overflow

        case underflow

        case malformed
    }
}
#endif
