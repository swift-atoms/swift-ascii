public enum ASCII {}

extension ASCII {

    public enum Character {}
}

extension ASCII {

    public enum Case {

        case upper

        case lower
    }
}

extension ASCII {

    public static let whitespaces: Set<ASCII.Code> = [
        .sp,
        .htab,
        .lf,
        .cr,
    ]
}
