#////////////////////////////////////////////////////////////////////
# Rationals

# See - https://github.com/justmoon/node-bignum
#       > Big integers for Node.js

util = require 'util'

bigdecimal = require 'bigdecimal'
sprintf = require('sprintf').sprintf

BIG_ZERO = new bigdecimal.BigInteger("0")
BIG_ONE = new bigdecimal.BigInteger("1")
BIG_MINUS_ONE = new bigdecimal.BigInteger("-1")
BIG_TEN = new bigdecimal.BigInteger("10")

# Class:Rational
# 有理数を現すためのクラス。
class Rational
  # constructor
  # Parameters:
  #  n - 分子  // bigdecimal, int, string
  #  d - 分母  // bigdecimal, int, string
  constructor: (n, d) ->
    throw "#--- Rational.constructor: n == undefined" if (n == undefined)
    n = new bigdecimal.BigInteger("" + n) unless n instanceof bigdecimal.BigInteger

    if (d == undefined)
      d = new bigdecimal.BigInteger("1")
    else if !(d instanceof bigdecimal.BigInteger)
      d = new bigdecimal.BigInteger("" + d)

    throw "#--- Rational.constructor: d == 0" if d.compareTo(BIG_ZERO) == 0

    d = new bigdecimal.BigInteger("1") if BIG_ZERO.compareTo(n) == 0

    if BIG_ZERO.compareTo(d) > 0
      n = n.negate()
      d = d.negate()

    @n = n
    @d = d

  # a と b の最大公約数を返す。
  gcd = (a, b) ->
    _gcd = (a, b) ->
      if b.compareTo(BIG_ZERO) == 0
        a
      else
        _gcd(b, a.remainder(b))

    _gcd(a.abs(), b.abs())

  # 最大公約数
  gratestCommonDiviser: ->
    gcd(@n.abs(), @d.abs())

  # 分子
  numerator: ->
    x = @n.abs().divide(@gratestCommonDiviser())
    x = x.negate() if (@n.compareTo(BIG_ZERO) < 0)
    x

  # 分母
  denominator: ->
    @d.abs().divide(@gratestCommonDiviser())

  # + Add
  add: (y) ->
    y = new Rational(y) unless (y instanceof Rational)

    n = @numerator().multiply(y.denominator()).add(y.numerator().multiply(@denominator()))
    d = @denominator().multiply(y.denominator())
    g = gcd(n, d)
    new Rational(n.divide(g), d.divide(g))
  
  # - subtrct
  sub: (y) ->
    y = new Rational(y) unless (y instanceof Rational)
    @.add(y.neg())

  # * mul
  mul: (y) ->
    y = new Rational(y) unless (y instanceof Rational)

    n = @numerator().multiply(y.numerator())
    d = @denominator().multiply(y.denominator())
    g = gcd(n, d)
    new Rational(n.divide(g), d.divide(g))

  # / div
  div: (y) ->
    y = new Rational(y) unless (y instanceof Rational)
    @.mul(y.inv())

  # 符号逆転
  neg: ->
    new Rational(@n.negate(), @d)
   
  # 逆数
  inv: ->
    throw "#--- Rational.inv: @n == 0" if @n.compareTo(BIG_ZERO) == 0
    new Rational(@d, @n)

  # 比較
  # -1: this < y,  0: this == y,  1: y < this
  compare: (y) ->
    y = new Rational(y) unless (y instanceof Rational)
    diffn = @numerator().multiply(y.denominator()).subtract(y.numerator().multiply(@denominator()))
    if diffn.compareTo(BIG_ZERO) > 0
      return 1
    else if diffn.compareTo(BIG_ZERO) < 0
      return -1
    return 0

  eq: (y) -> @compare(y) == 0
  lt: (y) -> @compare(y) < 0
  le: (y) -> @compare(y) <= 0
  gt: (y) -> @compare(y) > 0
  ge: (y) -> @compare(y) >= 0 
  
  #
  pow: (y) ->
    unless y instanceof bigdecimal.BigInteger
      throw "#--- Rational.pow: y is non-Integer" unless parseInt("" + y, 10) == parseFloat("" + y)
      y = new bigdecimal.BigInteger("" + y)

    throw "#--- Rational.pow: y is non-Integer" unless y.floatValue() == y.intValue() 
    throw "#--- Rational.pow: y is negative-Integer" if y.compareTo(BIG_ZERO) < 0

    new Rational(@numerator().pow(y), @denominator().pow(y))
  
  # float value or [+|-]Infinity
  floatValue: ->
    n = parseFloat @numerator()
    d = parseFloat @denominator()
    (1.0 * n) / d 

  #
  reduce: ->
    g = gcd(@n, @d)  
    new Rational(@n.divide(g), @d.divide(g))

  #
  toString: ->
    "#{@n.toString()}/#{@d.toString()}"

  #
  toRepeatString:  ->
    Rational.getRepeatString(@n, @d)

  @getRepeatString: (a, b) ->
    # See - http://ja.doukaku.org/9/
    #       > 分数を小数に展開 (循環小数は 0.{3} のように {} で循環部を示す)

    a = new bigdecimal.BigInteger("" + a) unless a instanceof bigdecimal.BigInteger
    b = new bigdecimal.BigInteger("" + b) unless b instanceof bigdecimal.BigInteger

    sign = if (a.compareTo(BIG_ZERO) < 0) then "-" else ""
    a = a.abs()
    b = b.abs()

    return "#{sign}#{a}" if b.compareTo(BIG_ONE) == 0

    m = []  # 余りを保存する   

    r = "#{a.divide(b).toString()}"
    r += "."  if a.remainder(b).compareTo(BIG_ZERO) > 0
    a = a.remainder(b)

    while a.compareTo(BIG_ZERO) > 0
      m.push a.toString()
      a = a.multiply(BIG_TEN)
      r += "#{a.divide(b).toString()}"
      a = a.remainder(b)

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
    throw "#--- Rational.parseFloat: Error: #{str}" if (r == null)

    [x, s, n0, dot, n1, m] = r
    # console.log "-----------     s = #{s}, n0 = #{n0}, n1 = #{n1}, m = #{m}"

    sign = if (s == "-") then BIG_MINUS_ONE else BIG_ONE
    p = parseInt(m, 10)
    n = new bigdecimal.BigInteger("#{n0}#{n1}").multiply(sign)
    d = new bigdecimal.BigInteger("1")
    if (p - n1.length > 0)
      n = n.multiply(new bigdecimal.BigInteger(strPow10(p - n1.length)))
    else
      d = new bigdecimal.BigInteger(strPow10(-p + n1.length))

    while (d.compareTo(BIG_ONE) > 0) and (n.abs().compareTo(BIG_ONE) > 0) and (n.remainder(BIG_TEN).compareTo(BIG_ZERO) == 0) 
      n = n.divide(BIG_TEN)
      d = d.divide(BIG_TEN)

    # console.log "n = #{n}, d = #{d}, v = #{n/d}"
    new Rational(n, d)

  #
  @parseStr: (str) ->
    repR = /^w*([+-]?)(\d+)\.?(\d*)\{(\d+)\}w*$/   # 循環小数
    fixpointR = /^w*([+-]?)(\d+)\.?(\d*)w*$/       # 小数

    pat = repR.exec(str)
    #util.log "-------- #{util.inspect(pat, false, null)}"
    if (pat)
      [x, s, a, b, c] = pat
      # console.log util.inspect(pat, false, null)
      sign = if (s == "-") then -1 else 1
      intPart = new Rational(new bigdecimal.BigInteger(a))
      nonRepeatPart = if (b == "") then new Rational(0) else new Rational(new bigdecimal.BigInteger(b), new bigdecimal.BigInteger(strPow10(b.length)))
      n = new bigdecimal.BigInteger(c)
      d = new bigdecimal.BigInteger(strPow10(c.length)).subtract(BIG_ONE).multiply(new bigdecimal.BigInteger(strPow10(b.length)))
      repeatPart = new Rational(n, d)
      return intPart.add(nonRepeatPart).add(repeatPart).mul(sign)

    else
      pat = fixpointR.exec(str)
      throw "#--- Rational.parseStr: Error: #{str}" if (pat == null)
      # util.log "-------- #{util.inspect(pat, false, null)}"
      [x, s, a, b] = pat
      sign = if (s == "-") then -1 else 1
      n = new bigdecimal.BigInteger("#{a}#{b}")
      d = new bigdecimal.BigInteger(strPow10(b.length))
      return new Rational(n, d).mul(sign)

module.exports = Rational
