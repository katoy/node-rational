#////////////////////////////////////////////////////////////////////
# Rationals

# See - https://github.com/justmoon/node-bignum
#       > Big integers for Node.js

util = require 'util'

bignum = require 'bignum'
sprintf = require('sprintf').sprintf

BIG_ZERO = bignum(0)

# Class:Rational
# 有理数を現すためのクラス。
class Rational
  # constructor
  # Parameters:
  #  n - 分子  // bignum, int, string
  #  d - 分母  // gibhum, int, string
  constructor: (n, d) ->
    throw "#--- constructor: n == undefined" if (n == undefined)
    n = bignum(n) unless n instanceof bignum

    if (d == undefined)
      d = bignum(1)
    else if !(d instanceof bignum)
      d = bignum(d)

    throw "#--- constructor: d == 0" if d.eq(0)


    d = bignum(1) if (BIG_ZERO.eq(n))

    if BIG_ZERO.gt(d)
      n = n.neg()
      d = d.neg()

    @n = n
    @d = d

  # a と b の最大公約数を返す。
  gcd = (a, b) ->
    _gcd = (a, b) ->
      if b.eq(0)
        a
      else
        _gcd(b, a.mod(b))

    _gcd(a.abs(), b.abs())

  # 最大公約数
  gratestCommonDiviser: ->
    gcd(@n.abs(), @d.abs())

  # 分子
  numerator: ->
    x = @n.abs().div(@gratestCommonDiviser())
    x = x.neg() if (@n.lt(0))
    x

  # 分母
  denominator: ->
    @d.abs().div(@gratestCommonDiviser())

  # + Add
  add: (y) ->
    y = new Rational(y) unless (y instanceof Rational)

    n = @numerator().mul(y.denominator()).add(y.numerator().mul(@denominator()))
    d = @denominator().mul(y.denominator())
    g = gcd(n, d)
    new Rational(n.div(g), d.div(g))
  
  # - subtrct
  sub: (y) ->
    y = new Rational(y) unless (y instanceof Rational)
    @.add(y.neg())

  # * mul
  mul: (y) ->
    y = new Rational(y) unless (y instanceof Rational)

    n = @numerator().mul(y.numerator())
    d = @denominator().mul(y.denominator())
    g = gcd(n, d)
    new Rational(n.div(g), d.div(g))

  # / div
  div: (y) ->
    y = new Rational(y) unless (y instanceof Rational)
    @.mul(y.inv())

  # 符号逆転
  neg: ->
    new Rational(@n.neg(), @d)
   
  # 逆数
  inv: ->
    throw "#--- inv: @n == 0" if @n.eq(0)
    new Rational(@d, @n)

  # 比較
  # -1: this < y,  0: this == y,  1: y < this
  compare: (y) ->
    y = new Rational(y) unless (y instanceof Rational)

    diffn = @numerator().mul(y.denominator()).sub(y.numerator().mul(@denominator()))
    if diffn.gt(0)
      return 1
    else if diffn.lt(0)
      return -1
    return 0

  eq: (y) -> @compare(y) == 0
  lt: (y) -> @compare(y) < 0
  le: (y) -> @compare(y) <= 0
  gt: (y) -> @compare(y) > 0
  ge: (y) -> @compare(y) >= 0 
  
  #
  pow: (y) ->
    y = new Rational(y) unless (y instanceof Rational)
    new Rational(@numerator().pow(y), @denominator().pow(y))
  
  # float value or [+|-]Infinity
  floatValue: ->
    n = parseFloat @numerator()
    d = parseFloat @denominator()
    (1.0 * n) / d 

  #
  reduce: ->
    g = gcd(@n, @d)  
    new Rational(@n.div(g), @d.div(g))

  #
  toString: ->
    "#{@n.toString()}/#{@d.toString()}"

  #
  toRepeatString:  ->
    Rational.getRepeatString(@n, @d)

  @getRepeatString: (a, b) ->
    # See - http://ja.doukaku.org/9/
    #       > 分数を小数に展開 (循環小数は 0.{3} のように {} で循環部を示す)

    a = bignum(a) unless a instanceof bignum
    b = bignum(b) unless b instanceof bignum

    sign = if (a.div(b).ge(0)) then "" else "-"
    a = a.abs()
    b = b.abs()

    return "#{sign}#{a}" if b.eq(1)

    m = []  # 余りを保存する   

    r = "#{a.div(b).toString()}."
    a = a.mod(b)

    while a.gt(0)
      m.push a.toString()
      a = a.mul(10)
      r += "#{a.div(b).toString()}"
      a = a.mod(b)

      i = m.indexOf(a.toString())
      # console.log "------ i=#{i}, #{util.inspect(m, false, null)}"
      if i >= 0  # 余りが繰り返えされたので...
        r = r.substring(0, i+2) + '{' + r.substring(i+2) + "}"
        break

    "#{sign}#{r}"
  
  #
  strPow10 = (p) ->
    zs = ''
    if p > 0
      zs += '0' for i in [1.. p]
      "1#{zs}"
    else if p == 0
      "1"
    else if p == -1
      "0.1"
    else
      zs += '0' for i in [p.. -2]
      "0.#{zs}1"

  #
  @parseFloat: (val) ->
    deR = /^w*([+-]?)(\d*)(\.?)(\d*?)e([+-]?\d+)w*$/i
    NUM_FORMAT = "%+.12e"

    str = sprintf("%+.12e", val)
    r = deR.exec(str)
    throw "#--- parseFloat: Error: #{str}" if (r == null)

    [x, s, n0, dot, n1, m] = r
    # console.log "-----------     s = #{s}, n0 = #{n0}, n1 = #{n1}, m = #{m}"

    sign = if (s == "-") then -1 else 1
    p = parseInt(m, 10)
    n = bignum("#{n0}#{n1}").mul(sign)
    d = bignum(1)
    if (p - n1.length > 0)
      n = n.mul(strPow10(p - n1.length))
    else
      d = bignum(strPow10(-p + n1.length))

    while (d.gt(1)) and (n.abs().gt(1)) and (n.mod(10).eq(0)) 
      n = n.div(10)
      d = d.div(10)

    # console.log "n = #{n}, d = #{d}, v = #{n/d}"
    new Rational(n, d)

  #
  @parseStr: (str) ->
    repR = /^w*([+-]?)(\d+)\.?(\d*)\{(\d+)\}w*$/   # 循環小数
    fixpointR = /^w*([+-]?)(\d+)\.?(\d*)2*$/       # 小数

    pat = repR.exec(str)
    # util.log "-------- #{util.inspect(pat, false, null)}"
    if (pat)
      [x, s, a, b, c] = pat
      # console.log util.inspect(pat, false, null)
      sign = if (s == "-") then -1 else 1
      intPart = new Rational(bignum(a))
      nonRepeatPart = if (b == "") then new Rational(0) else new Rational(bignum(b), bignum(strPow10(b.length)))
      n = bignum(c).mul(sign)
      d = bignum(strPow10(c.length)).sub(1).mul(bignum(strPow10(b.length)))
      repeatPart = new Rational(n, d)

      r = intPart.add(nonRepeatPart).add(repeatPart).mul(sign)

    else
      pat = fixpointR.exec(str)
      # util.log "-------- #{util.inspect(pat, false, null)}"
      [x, s, a, b] = pat
      sign = if (s == "-") then -1 else 1
      n = bignum("#{a}#{b}")
      d = bignum(strPow10(b.length))
      return new Rational(n, d).mul(sign)

module.exports = Rational
