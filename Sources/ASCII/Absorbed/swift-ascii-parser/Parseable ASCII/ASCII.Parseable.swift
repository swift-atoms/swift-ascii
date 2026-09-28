#if Parser
public import Byte

extension ASCII {

    public protocol Parseable {

        associatedtype Failure: Swift.Error

        init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Failure)
        where Bytes.Element == Byte
    }
}
#endif
