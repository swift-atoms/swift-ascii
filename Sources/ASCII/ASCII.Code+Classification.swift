extension ASCII.Code {

    @_transparent
    public var isASCII: Bool {
        ASCII.Validation.isASCII(underlying)
    }

    @_transparent
    public var isWhitespace: Bool {
        ASCII.Classification.isWhitespace(underlying)
    }

    @_transparent
    public var isControl: Bool {
        ASCII.Classification.isControl(underlying)
    }

    @_transparent
    public var isVisible: Bool {
        ASCII.Classification.isVisible(underlying)
    }

    @_transparent
    public var isPrintable: Bool {
        ASCII.Classification.isPrintable(underlying)
    }

    @_transparent
    public var isDigit: Bool {
        ASCII.Classification.isDigit(underlying)
    }

    @_transparent
    public var isHexDigit: Bool {
        ASCII.Classification.isHexDigit(underlying)
    }

    @_transparent
    public var isLetter: Bool {
        ASCII.Classification.isLetter(underlying)
    }

    @_transparent
    public var isAlphanumeric: Bool {
        ASCII.Classification.isAlphanumeric(underlying)
    }

    @_transparent
    public var isUppercase: Bool {
        ASCII.Classification.isUppercase(underlying)
    }

    @_transparent
    public var isLowercase: Bool {
        ASCII.Classification.isLowercase(underlying)
    }

    @_transparent
    public func lowercased() -> ASCII.Code {
        ASCII.Case.Conversion.convert(self, to: .lower)
    }

    @_transparent
    public func uppercased() -> ASCII.Code {
        ASCII.Case.Conversion.convert(self, to: .upper)
    }
}
