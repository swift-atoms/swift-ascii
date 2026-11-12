#if Serializer
    extension Swift.String {

        public init<Value: ASCII.Serializable>(ascii value: Value) {
            self.init(decoding: value.asciiCodes.map({ $0.underlying }), as: Swift.UTF8.self)
        }
    }
#endif
