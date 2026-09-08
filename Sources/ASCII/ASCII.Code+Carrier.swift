public import Carrier

/// Treats an ASCII code as a carrier of its underlying byte.
extension ASCII.Code: Carrier.`Protocol` {

    public typealias Underlying = UInt8

}
