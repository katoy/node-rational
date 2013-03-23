assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/Rational' else  'lib/Rational'  
libPath = path.join __dirname, '..', libPath
Rational = require libPath
bignum = require 'bignum'

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "add", ->
  it "1/2 + 1 = 3/2", ->
    r1 = new Rational(1,2)
    r2 = new Rational(1)
    r = r1.add(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 2"
    assert.equal r.toString(), "3/2"

  it "1/2 + 1/3 = 5/6", ->
    r1 = new Rational(1,2)
    r2 = new Rational(1,3)
    r = r1.add(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "5, 6"
    assert.equal r.toString(), "5/6"

  it "1/12 + 1/4 = 1/3", ->
    r1 = new Rational(1,12)
    r2 = new Rational(1,4)
    r = r1.add(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "1/3"

  it "1/3 + 1 = 4/3", ->
    r1 = new Rational(1,3)
    r = r1.add(1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "4, 3"
    assert.equal r.toString(), "4/3"

describe "sub", ->
  it "1/2 - 1 = 3/2", ->
    r1 = new Rational(1,2)
    r2 = new Rational(1)
    r = r1.sub(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 2"
    assert.equal r.toString(), "-1/2"

  it "1/2 - 1/3 = 1/6", ->
    r1 = new Rational(1,2)
    r2 = new Rational(1,3)
    r = r1.sub(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 6"
    assert.equal r.toString(), "1/6"

  it "1/12 - 1/4 = -1/6", ->
    r1 = new Rational(1,12)
    r2 = new Rational(1,4)
    r = r1.sub(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 6"
    assert.equal r.toString(), "-1/6"

  it "1/3 - 1 = -2/3", ->
    r1 = new Rational(1,3)
    r = r1.sub(1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-2, 3"
    assert.equal r.toString(), "-2/3"

describe "mult", ->
  it "1/2 * 3 = 3/2", ->
    r1 = new Rational(1,2)
    r2 = new Rational(3)
    r = r1.mul(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 2"
    assert.equal r.toString(), "3/2"

  it "2/3 * 1/2 = 1/5", ->
    r1 = new Rational(2,3)
    r2 = new Rational(1,2)
    r = r1.mul(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "1/3"

  it "2/3 * 1/4 = 1/6", ->
    r1 = new Rational(2,3)
    r2 = new Rational(1,4)
    r = r1.mul(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 6"
    assert.equal r.toString(), "1/6"

  it "2/3 * 2 = 4/3", ->
    r1 = new Rational(2,3)
    r = r1.mul(2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "4, 3"
    assert.equal r.toString(), "4/3"

describe "div", ->
  it "2/3 / 2 = 1/3", ->
    r1 = new Rational(2,3)
    r2 = new Rational(2)
    r = r1.div(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "1/3"

  it "2/3 / 1/2 = 4/3", ->
    r1 = new Rational(2,3)
    r2 = new Rational(1,2)
    r = r1.div(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "4, 3"
    assert.equal r.toString(), "4/3"

  it "2/3 / 1/4 = 8/3", ->
    r1 = new Rational(2,3)
    r2 = new Rational(1,4)
    r = r1.div(r2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "8, 3"
    assert.equal r.toString(), "8/3"

  it "2/3 / 2 = 1/3", ->
    r1 = new Rational(2,3)
    r = r1.div(2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "1/3"

describe "pow", ->
  it "2/3 pow 2 -> 4/9", ->
    assert.equal (new Rational(2, 3)).pow(2).toString(), '4/9'

  it "2/3 pow 3 -> 8/27", ->
    assert.equal (new Rational(2, 3)).pow(3).toString(), '8/27'

  it "4/9 pow 0.5 -> 1/1", ->
    assert.equal (new Rational(4, 9)).pow(0.5).toString(), '1/1'

describe "floatValue", ->
  it "1/3 -> 0.33333...", ->
    r = new Rational(1, 3)
    assert.equal r.floatValue(), 1/3

  it "1.000000000001 -> 1.000000000001", ->
    r = Rational.parseFloat(1.000000000001)
    assert.equal r.floatValue(), 1.000000000001

  it "0 -> 0", ->
    r = Rational.parseFloat(0)
    assert.equal r.floatValue(), 0

  it "Number.MAX_VALUE(1.797693134862e+308) -> 1.797693134862e+308", ->
    r = Rational.parseFloat(1.797693134862e+308)
    assert.equal r.floatValue(), 1.797693134862e+308

  it "1.0001e-300 -> 1.0001e-300", ->
    r = Rational.parseFloat(1.0001e-300)
    assert.equal r.floatValue(), 1.0001e-300

  it "-1.0001e-300 -> -1.0001e-300", ->
    r = Rational.parseFloat(-1.0001e-300)
    assert.equal r.floatValue(), -1.0001e-300
    
describe "reduce", ->
  it "2/10 -> 1/5", ->
    r = new Rational(2, 10)
    assert.equal r.toString(), "2/10"
    assert.equal r.reduce().toString(), "1/5"

  it "-2/10 -> -1/5", ->
    r = new Rational(-2, 10)
    assert.equal r.toString(), "-2/10"
    assert.equal r.reduce().toString(), "-1/5"

describe "compare", ->
  it "1/2 <> 1/3", ->
    r2 = new Rational(1,2)
    r3 = new Rational(1,3)
    assert.equal r2.compare(r2), 0
    assert.equal r2.compare(r3), 1
    assert.equal r3.compare(r2), -1

  it "1/2 <> 1/3", ->
    r2 = new Rational(1,2)
    r3 = new Rational(1,3)

    assert.equal r2.le(r2), true 
    assert.equal r2.lt(r2), false 
    assert.equal r2.ge(r2), true 
    assert.equal r2.gt(r2), false 
    assert.equal r2.eq(r2), true 

    assert.equal r2.le(r3), false 
    assert.equal r2.lt(r3), false 
    assert.equal r2.ge(r3), true 
    assert.equal r2.gt(r3), true 
    assert.equal r2.eq(r3), false

    assert.equal r3.le(r2), true 
    assert.equal r3.lt(r2), true 
    assert.equal r3.ge(r2), false 
    assert.equal r3.gt(r2), false
    assert.equal r3.eq(r2), false 

  it "2 <> int", ->
    r2 = new Rational(2)
    assert.equal r2.compare(3), -1
    assert.equal r2.compare(2), 0
    assert.equal r2.compare(1), 1

  it "0.{9} == 1", ->
    r2 = new Rational.parseStr("0.{9}")
    assert.equal r2.eq(1), true

  it "1.{0} == 1", ->
    r2 = new Rational.parseStr("1.{0}")
    assert.equal r2.eq(1), true

describe "neg", ->
  it "2/4 neg -> -2/4", ->
    r = new Rational(2,4)
    r = r.neg()
    assert.equal r.toString(), "-2/4"

describe "inv", ->
  it "2/3 inv = 3/2", ->
    r = new Rational(2,3)
    r = r.inv()
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 2"
    assert.equal r.toString(), "3/2"

  it "Rational(0).inv() -> error", ->
    try
      r = new Rational(0)
      r.inv()
      assert.true(false)
    catch e
      assert.equal(e.toString(), '#--- Rational.inv: @n == 0')

#describe "Rational.strPow10", ->
#  it "", ->
#    assert.equal Rational.strPow10(0), '1'
#    assert.equal Rational.strPow10(1), '10'
#    assert.equal Rational.strPow10(2), '100'
#    assert.equal Rational.strPow10(3), '1000'
#
#    assert.equal Rational.strPow10(-1), '0.1'
#    assert.equal Rational.strPow10(-2), '0.01'
#    assert.equal Rational.strPow10(-3), '0.001'

