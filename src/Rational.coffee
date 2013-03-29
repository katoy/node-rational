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

BASE_LETTERS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
BASE_MAX_INT = BASE_LETTERS.length
BASE_MAX = new bigdecimal.BigInteger("#{BASE_MAX_INT}")

#isString = (s) ->
#  (typeof(s) == 'string') or (s instanceof String)

# Class:Rational
# 有理数を現すためのクラス。
class Rational
  # constructor
  # Parameters:
  #  n - 分子  // bigdecimal, int, string
  #  d - 分母  // bigdecimal, int, string
  constructor: (n, d) ->
    throw "#--- Rational.constructor: n == undefined" if (n == undefined)
    n = new bigdecimal.BigInteger("#{n}") unless n instanceof bigdecimal.BigInteger

    if (d == undefined)
      d = new bigdecimal.BigInteger("1")
    else if !(d instanceof bigdecimal.BigInteger)
      d = new bigdecimal.BigInteger("#{d}")

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
    yV = parseInt("#{y}")
    throw "#--- Rational.pow: Error: '#{y}'" if isNaN(yV)
    throw "#--- Rational.pow: '#{y}' is not Integer" unless "#{y}" == "#{yV}"

    y = new bigdecimal.BigInteger("#{y}")

    throw "#--- Rational.pow: '#{y}' is negative-Integer" if y.compareTo(BIG_ZERO) < 0

    new Rational(@numerator().pow(y), @denominator().pow(y))
  
  # float value or [+|-]Infinity
  floatValue: ->
    n = parseFloat @numerator()
    d = parseFloat @denominator()
    (1.0 * n) / d 

  # 規約分数にする。
  reduce: ->
    g = gcd(@n, @d)  
    new Rational(@n.divide(g), @d.divide(g))

  # 10 進数表記での分数表記を得る.
  toString: ->
    @toStringN(10, false)

  # N 進数 (base) 表記での分数表記を得る.
  # base: bigdecimal or integer
  #       default = 10
  toStringN: (base = 10, show_base = true)->
    "#{Rational.toStringN(@n, base, show_base)}/#{Rational.toStringN(@d, base, show_base)}"

  # N 進数 (base) 表記を得る.
  # bd: bigdecimal
  # base: bigdecimal or integer
  #       default = 10
  # show_base 
  @toStringN: (bd, base = 10, show_base = true) ->
    baseV = parseInt("#{base}") 
    throw "#--- Rational.toStringN: Error: '#{base}'" if isNaN(baseV)
    throw "#--- Rational.parseStr: '#{base}' is not Integer" unless "#{base}" == "#{Math.floor(baseV)}"
    bs = new bigdecimal.BigInteger("#{baseV}")
    throw "#--- Rational.toStringN: '#{base}' <= 1" if bs.compareTo(BIG_ONE) <= 0
    throw "#--- Rational.toStringN: '#{base}' >= #{BASE_MAX_INT}" if bs.compareTo(BASE_MAX) > 0
    # return bd.toString() if bs.compareTo(BIG_TEN) == 0

    ans = ''
    sign = if (bd.compareTo(BIG_ZERO) < 0) then "-" else ""
    a = new bigdecimal.BigInteger("#{bd.abs()}")

    return "#{sign}#{a}" if a.compareTo(BIG_ONE) == 0
    return "0"           if a.compareTo(BIG_ZERO) == 0

    while(true)
      qr = a.divideAndRemainder(bs)
      ans = BASE_LETTERS.charAt(qr[1].intValue()) + ans
      a = qr[0]   
      break if qr[0].compareTo(BIG_ZERO) == 0

    base_notation = if ((show_base == true) and (ans != "0") and (ans != "1")) then "_#{base}" else ""
    "#{sign}#{ans}#{base_notation}"

  toRepeatString:  ->
    Rational.getRepeatStringN(@n, @d, 10, false)

  toRepeatStringN: (base = 10, show_base = true) ->
    Rational.getRepeatStringN(@n, @d, base, show_base)

  @getRepeatString: (a, b) ->
    @getRepeatStringN(a, b, 10, false)

  @getRepeatStringN: (a, b, base = 10, show_base = true) ->
    # See - http://ja.doukaku.org/9/
    #       > 分数を小数に展開 (循環小数は 0.{3} のように {} で循環部を示す)
    baseV = parseInt("#{base}") 
    throw "#--- Rational.toRepeatStringN: Error: '#{base}'" if isNaN(baseV)
    throw "#--- Rational.parseStr: '#{base}' is not Integer" unless "#{base}" == "#{Math.floor(baseV)}"
    bs = new bigdecimal.BigInteger("#{baseV}")
    throw "#--- Rational.toRepeatStringN: '#{base}' <= 1" if bs.compareTo(BIG_ONE) <= 0
    throw "#--- Rational.toRepeatStringN: '#{base}' >= #{BASE_MAX_INT}" if bs.compareTo(BASE_MAX) > 0

    a = new bigdecimal.BigInteger("#{a}") unless a instanceof bigdecimal.BigInteger
    b = new bigdecimal.BigInteger("#{b}") unless b instanceof bigdecimal.BigInteger

    sign = if (a.compareTo(BIG_ZERO) < 0) then "-" else ""
    a = a.abs()
    b = b.abs()

    return "0"           if a.compareTo(BIG_ZERO) == 0
    return "#{sign}#{a}" if a.compareTo(b) == 0

    m = []  # 余りを保存する   

    qr = a.divideAndRemainder(b)
    r = Rational.toStringN(qr[0], bs, false)
    r += "."  if qr[1].compareTo(BIG_ZERO) > 0
    pre_len = r.length
    a = qr[1]

    while a.compareTo(BIG_ZERO) > 0
      m.push a.toString()
      a = a.multiply(bs)
      qr = a.divideAndRemainder(b)
      r += BASE_LETTERS.charAt(qr[0].intValue())
      a = qr[1]

      i = m.indexOf(a.toString())
      # console.log "------ i=#{i}, #{util.inspect(m, false, null)}"
      if i >= 0  # 余りが繰り返えされたので...
        r = r.substring(0, i + pre_len) + '{' + r.substring(i + pre_len) + "}"
        break

    base_notation = if ((show_base == true) and (r != "0") and (r != "1")) then "_#{base}" else ""
    "#{sign}#{r}#{base_notation}"
  
  #
  strPow10 = (p) ->
    zs = ''
    if p >= 0
      zs += '0' for i in [1.. p]
      "1#{zs}"
    else
      zs += '0' for i in [p.. -2]
      "0.#{zs}1"

  #
  @parseFloat: (val) ->
    deR = /^w*([+-]?)(\d*)(\.?)(\d*?)e([+-]?\d+)w*$/i
    NUM_FORMAT = "%+.12e"

    str = sprintf("%+.12e", val)
    r = deR.exec(str)
    throw "#--- Rational.parseFloat: Error: '#{str}'" if (r == null)

    [x, s, n0, dot, n1, m] = r
    # console.log "-----------     s = #{s}, n0 = #{n0}, n1 = #{n1}, m = #{m}"

    sign = if (s == "-") then BIG_MINUS_ONE else BIG_ONE
    p = parseInt(m, 10)
    throw "#--- Rational.parseFloat: Error: '#{m}'" if isNaN(p)

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
  @parseStr: (str, base = "10") ->
    baseV = parseInt("#{base}") 
    throw "#--- Rational.parseStr: Error: '#{base}'" if isNaN(baseV)
    throw "#--- Rational.parseStr: '#{base}' is not Integer" unless "#{base}" == "#{Math.floor(baseV)}"
    throw "#--- Rational.parseStr: '#{base}' <= 1" if base <= 1
    throw "#--- Rational.parseStr: '#{base}' >= #{BASE_MAX_INT}" if base >= BASE_MAX_INT

    repR = /^w*([+-]?)(\d+)\.?(\d*)\{(\d+)\}w*$/   # 循環小数
    fixpointR = /^w*([+-]?)(\d+)\.?(\d*)w*$/       # 小数

    pat = repR.exec(str)
    #util.log "-------- #{util.inspect(pat, false, null)}"
    if (pat)
      [x, s, a, b, c] = pat
      # console.log util.inspect(pat, false, null)
      sign = if (s == "-") then -1 else 1
      intPart = new Rational(Rational.getBigIntegerBaseN(a, base))
      powb = "1" + Array(b.length + 1).join("0")   # Append "0" (b.lenght) times.
      nonRepeatPart = if (b == "") then new Rational(0) else new Rational(Rational.getBigIntegerBaseN(b, base), Rational.getBigIntegerBaseN(powb, base))
      n = Rational.getBigIntegerBaseN(c, base)
      powc = "1" + Array(c.length + 1).join("0")   # Append "0" (c.lenght) times.
      d = Rational.getBigIntegerBaseN(powc, base).subtract(BIG_ONE).multiply(Rational.getBigIntegerBaseN(powb, base))
      repeatPart = new Rational(n, d)
      return intPart.add(nonRepeatPart).add(repeatPart).mul(sign)

    else
      pat = fixpointR.exec(str)
      throw "#--- Rational.parseStr: Error: '#{str}'" if (pat == null)
      # util.log "-------- #{util.inspect(pat, false, null)}"
      [x, s, a, b] = pat
      sign = if (s == "-") then -1 else 1
      n = Rational.getBigIntegerBaseN("#{a}#{b}", base)
      powb = "1" + Array(b.length + 1).join("0")   # Append "0" (b.lenght) times.
      d = Rational.getBigIntegerBaseN(powb, base)
      return new Rational(n, d).mul(sign)

  @getBigIntegerBaseN: (intstr, base = 10) ->
    baseV = parseInt("#{base}") 
    throw "#--- Rational.getBigIntegerBaseN: Error: '#{base}'" if isNaN(baseV)
    throw "#--- Rational.getBigIntegerBaseN: '#{base}' is not Integer" unless "#{base}" == "#{baseV}"
    throw "#--- Rational.getBigIntegerBaseN: '#{base}' <= 1" if baseV <= 1
    throw "#--- Rational.getBigIntegerBaseN: '#{base}' >= #{BASE_MAX_INT}" if baseV >= BASE_MAX_INT

    bs = bigdecimal.BigInteger("#{baseV}")
    n = bigdecimal.BigInteger("0")

    for c in intstr.split("")
      p = BASE_LETTERS.indexOf(c)
      throw "#--- Rational.getBigIntegerBaseN: '#{c}' is not in ['0' .. '#{BASE_LETTERS.charAt(base-1)}']" if p < 0 or p >= base
      n = n.multiply(bs).add(new bigdecimal.BigInteger("#{p}"))

    n

module.exports = Rational
