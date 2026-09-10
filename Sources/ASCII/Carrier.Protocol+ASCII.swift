public import Carrier

extension Carrier.`Protocol` where Underlying == UInt8 {

    @inlinable
    public static var ascii: ASCII.Namespace<Self>.Type {
        ASCII.Namespace<Self>.self
    }
}

extension ASCII {

    @frozen
    public enum Namespace<Owner: Carrier.`Protocol`> where Owner.Underlying == UInt8 {}
}

extension ASCII.Namespace {

    public static var nul: Owner { Owner(ASCII.Code.nul.underlying) }

    public static var soh: Owner { Owner(ASCII.Code.soh.underlying) }

    public static var stx: Owner { Owner(ASCII.Code.stx.underlying) }

    public static var etx: Owner { Owner(ASCII.Code.etx.underlying) }

    public static var eot: Owner { Owner(ASCII.Code.eot.underlying) }

    public static var enq: Owner { Owner(ASCII.Code.enq.underlying) }

    public static var ack: Owner { Owner(ASCII.Code.ack.underlying) }

    public static var bel: Owner { Owner(ASCII.Code.bel.underlying) }

    public static var bs: Owner { Owner(ASCII.Code.bs.underlying) }

    public static var htab: Owner { Owner(ASCII.Code.htab.underlying) }

    public static var tab: Owner { Owner(ASCII.Code.tab.underlying) }

    public static var lf: Owner { Owner(ASCII.Code.lf.underlying) }

    public static var newline: Owner { Owner(ASCII.Code.newline.underlying) }

    public static var vtab: Owner { Owner(ASCII.Code.vtab.underlying) }

    public static var ff: Owner { Owner(ASCII.Code.ff.underlying) }

    public static var cr: Owner { Owner(ASCII.Code.cr.underlying) }

    public static var so: Owner { Owner(ASCII.Code.so.underlying) }

    public static var si: Owner { Owner(ASCII.Code.si.underlying) }

    public static var dle: Owner { Owner(ASCII.Code.dle.underlying) }

    public static var dc1: Owner { Owner(ASCII.Code.dc1.underlying) }

    public static var dc2: Owner { Owner(ASCII.Code.dc2.underlying) }

    public static var dc3: Owner { Owner(ASCII.Code.dc3.underlying) }

    public static var dc4: Owner { Owner(ASCII.Code.dc4.underlying) }

    public static var nak: Owner { Owner(ASCII.Code.nak.underlying) }

    public static var syn: Owner { Owner(ASCII.Code.syn.underlying) }

    public static var etb: Owner { Owner(ASCII.Code.etb.underlying) }

    public static var can: Owner { Owner(ASCII.Code.can.underlying) }

    public static var em: Owner { Owner(ASCII.Code.em.underlying) }

    public static var sub: Owner { Owner(ASCII.Code.sub.underlying) }

    public static var esc: Owner { Owner(ASCII.Code.esc.underlying) }

    public static var fs: Owner { Owner(ASCII.Code.fs.underlying) }

    public static var gs: Owner { Owner(ASCII.Code.gs.underlying) }

    public static var rs: Owner { Owner(ASCII.Code.rs.underlying) }

    public static var us: Owner { Owner(ASCII.Code.us.underlying) }

    public static var del: Owner { Owner(ASCII.Code.del.underlying) }
}

extension ASCII.Namespace {

    public static var sp: Owner { Owner(ASCII.Code.sp.underlying) }

    public static var space: Owner { Owner(ASCII.Code.space.underlying) }
}

extension ASCII.Namespace {

    public static var exclamationPoint: Owner { Owner(ASCII.Code.exclamationPoint.underlying) }

    public static var exclamationMark: Owner { Owner(ASCII.Code.exclamationMark.underlying) }

    public static var quotationMark: Owner { Owner(ASCII.Code.quotationMark.underlying) }

    public static var dquote: Owner { Owner(ASCII.Code.dquote.underlying) }

    public static var doubleQuote: Owner { Owner(ASCII.Code.doubleQuote.underlying) }

    public static var numberSign: Owner { Owner(ASCII.Code.numberSign.underlying) }

    public static var dollarSign: Owner { Owner(ASCII.Code.dollarSign.underlying) }

    public static var percentSign: Owner { Owner(ASCII.Code.percentSign.underlying) }

    public static var ampersand: Owner { Owner(ASCII.Code.ampersand.underlying) }

    public static var apostrophe: Owner { Owner(ASCII.Code.apostrophe.underlying) }

    public static var leftParenthesis: Owner { Owner(ASCII.Code.leftParenthesis.underlying) }

    public static var rightParenthesis: Owner { Owner(ASCII.Code.rightParenthesis.underlying) }

    public static var asterisk: Owner { Owner(ASCII.Code.asterisk.underlying) }

    public static var plusSign: Owner { Owner(ASCII.Code.plusSign.underlying) }

    public static var plus: Owner { Owner(ASCII.Code.plus.underlying) }

    public static var comma: Owner { Owner(ASCII.Code.comma.underlying) }

    public static var hyphen: Owner { Owner(ASCII.Code.hyphen.underlying) }

    public static var period: Owner { Owner(ASCII.Code.period.underlying) }

    public static var slant: Owner { Owner(ASCII.Code.slant.underlying) }

    public static var solidus: Owner { Owner(ASCII.Code.solidus.underlying) }

    public static var slash: Owner { Owner(ASCII.Code.slash.underlying) }

    public static var forwardSlash: Owner { Owner(ASCII.Code.forwardSlash.underlying) }
}

extension ASCII.Namespace {

    public static var `0`: Owner { Owner(ASCII.Code.`0`.underlying) }

    public static var `1`: Owner { Owner(ASCII.Code.`1`.underlying) }

    public static var `2`: Owner { Owner(ASCII.Code.`2`.underlying) }

    public static var `3`: Owner { Owner(ASCII.Code.`3`.underlying) }

    public static var `4`: Owner { Owner(ASCII.Code.`4`.underlying) }

    public static var `5`: Owner { Owner(ASCII.Code.`5`.underlying) }

    public static var `6`: Owner { Owner(ASCII.Code.`6`.underlying) }

    public static var `7`: Owner { Owner(ASCII.Code.`7`.underlying) }

    public static var `8`: Owner { Owner(ASCII.Code.`8`.underlying) }

    public static var `9`: Owner { Owner(ASCII.Code.`9`.underlying) }
}

extension ASCII.Namespace {

    public static var colon: Owner { Owner(ASCII.Code.colon.underlying) }

    public static var semicolon: Owner { Owner(ASCII.Code.semicolon.underlying) }

    public static var lessThanSign: Owner { Owner(ASCII.Code.lessThanSign.underlying) }

    public static var lt: Owner { Owner(ASCII.Code.lt.underlying) }

    public static var lessThan: Owner { Owner(ASCII.Code.lessThan.underlying) }

    public static var equalsSign: Owner { Owner(ASCII.Code.equalsSign.underlying) }

    public static var greaterThanSign: Owner { Owner(ASCII.Code.greaterThanSign.underlying) }

    public static var gt: Owner { Owner(ASCII.Code.gt.underlying) }

    public static var greaterThan: Owner { Owner(ASCII.Code.greaterThan.underlying) }

    public static var questionMark: Owner { Owner(ASCII.Code.questionMark.underlying) }

    public static var commercialAt: Owner { Owner(ASCII.Code.commercialAt.underlying) }

    public static var at: Owner { Owner(ASCII.Code.at.underlying) }

    public static var atSign: Owner { Owner(ASCII.Code.atSign.underlying) }
}

extension ASCII.Namespace {

    public static var A: Owner { Owner(ASCII.Code.A.underlying) }

    public static var B: Owner { Owner(ASCII.Code.B.underlying) }

    public static var C: Owner { Owner(ASCII.Code.C.underlying) }

    public static var D: Owner { Owner(ASCII.Code.D.underlying) }

    public static var E: Owner { Owner(ASCII.Code.E.underlying) }

    public static var F: Owner { Owner(ASCII.Code.F.underlying) }

    public static var G: Owner { Owner(ASCII.Code.G.underlying) }

    public static var H: Owner { Owner(ASCII.Code.H.underlying) }

    public static var I: Owner { Owner(ASCII.Code.I.underlying) }

    public static var J: Owner { Owner(ASCII.Code.J.underlying) }

    public static var K: Owner { Owner(ASCII.Code.K.underlying) }

    public static var L: Owner { Owner(ASCII.Code.L.underlying) }

    public static var M: Owner { Owner(ASCII.Code.M.underlying) }

    public static var N: Owner { Owner(ASCII.Code.N.underlying) }

    public static var O: Owner { Owner(ASCII.Code.O.underlying) }

    public static var P: Owner { Owner(ASCII.Code.P.underlying) }

    public static var Q: Owner { Owner(ASCII.Code.Q.underlying) }

    public static var R: Owner { Owner(ASCII.Code.R.underlying) }

    public static var S: Owner { Owner(ASCII.Code.S.underlying) }

    public static var T: Owner { Owner(ASCII.Code.T.underlying) }

    public static var U: Owner { Owner(ASCII.Code.U.underlying) }

    public static var V: Owner { Owner(ASCII.Code.V.underlying) }

    public static var W: Owner { Owner(ASCII.Code.W.underlying) }

    public static var X: Owner { Owner(ASCII.Code.X.underlying) }

    public static var Y: Owner { Owner(ASCII.Code.Y.underlying) }

    public static var Z: Owner { Owner(ASCII.Code.Z.underlying) }
}

extension ASCII.Namespace {

    public static var leftBracket: Owner { Owner(ASCII.Code.leftBracket.underlying) }

    public static var leftSquareBracket: Owner { Owner(ASCII.Code.leftSquareBracket.underlying) }

    public static var reverseSlant: Owner { Owner(ASCII.Code.reverseSlant.underlying) }

    public static var reverseSolidus: Owner { Owner(ASCII.Code.reverseSolidus.underlying) }

    public static var backslash: Owner { Owner(ASCII.Code.backslash.underlying) }

    public static var rightBracket: Owner { Owner(ASCII.Code.rightBracket.underlying) }

    public static var rightSquareBracket: Owner { Owner(ASCII.Code.rightSquareBracket.underlying) }

    public static var circumflexAccent: Owner { Owner(ASCII.Code.circumflexAccent.underlying) }

    public static var circumflex: Owner { Owner(ASCII.Code.circumflex.underlying) }

    public static var underline: Owner { Owner(ASCII.Code.underline.underlying) }

    public static var underscore: Owner { Owner(ASCII.Code.underscore.underlying) }

    public static var lowLine: Owner { Owner(ASCII.Code.lowLine.underlying) }

    public static var leftSingleQuotationMark: Owner { Owner(ASCII.Code.leftSingleQuotationMark.underlying) }

    public static var graveAccent: Owner { Owner(ASCII.Code.graveAccent.underlying) }

    public static var backtick: Owner { Owner(ASCII.Code.backtick.underlying) }
}

extension ASCII.Namespace {

    public static var a: Owner { Owner(ASCII.Code.a.underlying) }

    public static var b: Owner { Owner(ASCII.Code.b.underlying) }

    public static var c: Owner { Owner(ASCII.Code.c.underlying) }

    public static var d: Owner { Owner(ASCII.Code.d.underlying) }

    public static var e: Owner { Owner(ASCII.Code.e.underlying) }

    public static var f: Owner { Owner(ASCII.Code.f.underlying) }

    public static var g: Owner { Owner(ASCII.Code.g.underlying) }

    public static var h: Owner { Owner(ASCII.Code.h.underlying) }

    public static var i: Owner { Owner(ASCII.Code.i.underlying) }

    public static var j: Owner { Owner(ASCII.Code.j.underlying) }

    public static var k: Owner { Owner(ASCII.Code.k.underlying) }

    public static var l: Owner { Owner(ASCII.Code.l.underlying) }

    public static var m: Owner { Owner(ASCII.Code.m.underlying) }

    public static var n: Owner { Owner(ASCII.Code.n.underlying) }

    public static var o: Owner { Owner(ASCII.Code.o.underlying) }

    public static var p: Owner { Owner(ASCII.Code.p.underlying) }

    public static var q: Owner { Owner(ASCII.Code.q.underlying) }

    public static var r: Owner { Owner(ASCII.Code.r.underlying) }

    public static var s: Owner { Owner(ASCII.Code.s.underlying) }

    public static var t: Owner { Owner(ASCII.Code.t.underlying) }

    public static var u: Owner { Owner(ASCII.Code.u.underlying) }

    public static var v: Owner { Owner(ASCII.Code.v.underlying) }

    public static var w: Owner { Owner(ASCII.Code.w.underlying) }

    public static var x: Owner { Owner(ASCII.Code.x.underlying) }

    public static var y: Owner { Owner(ASCII.Code.y.underlying) }

    public static var z: Owner { Owner(ASCII.Code.z.underlying) }
}

extension ASCII.Namespace {

    public static var leftBrace: Owner { Owner(ASCII.Code.leftBrace.underlying) }

    public static var leftCurlyBracket: Owner { Owner(ASCII.Code.leftCurlyBracket.underlying) }

    public static var verticalLine: Owner { Owner(ASCII.Code.verticalLine.underlying) }

    public static var rightBrace: Owner { Owner(ASCII.Code.rightBrace.underlying) }

    public static var rightCurlyBracket: Owner { Owner(ASCII.Code.rightCurlyBracket.underlying) }

    public static var tilde: Owner { Owner(ASCII.Code.tilde.underlying) }
}
