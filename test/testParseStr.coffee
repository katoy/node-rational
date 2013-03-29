assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/Rational' else  'lib/Rational'  
libPath = path.join __dirname, '..', libPath
Rational = require libPath

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "parseStr", ->
  it "0 -> 0/1", ->
    r = Rational.parseStr("0")
    assert.equal r.toString(), "0/1"

  it "+0 -> 0/1", ->
    r = Rational.parseStr("0")
    assert.equal r.toString(), "0/1"

  it "-0 -> 0/1", ->
    r = Rational.parseStr("0")
    assert.equal r.toString(), "0/1"

  it "1 -> 1/1", ->
    r = Rational.parseStr("1")
    assert.equal r.toString(), "1/1"

  it "-1 -> 1/1", ->
    r = Rational.parseStr("-1")
    assert.equal r.toString(), "-1/1"

  it "+1 -> 1/1", ->
    r = Rational.parseStr("+1")
    assert.equal r.toString(), "1/1"

  it "10 -> 10/1", ->
    r = Rational.parseStr("10")
    assert.equal r.toString(), "10/1"

  it "-10 -> -10/1", ->
    r = Rational.parseStr("-10")
    assert.equal r.toString(), "-10/1"

  it "+10 -> 10/1", ->
    r = Rational.parseStr("+10")
    assert.equal r.toString(), "10/1"

  it "123456789 -> 123456789/1", ->
    r = Rational.parseStr("123456789")
    assert.equal r.toString(), "123456789/1"

  it "1.23456789 -> 123456789/100000000", ->
    r = Rational.parseStr("1.23456789")
    assert.equal r.toString(), "123456789/100000000"

  it "1.23456789123456789 -> 123456789123456789/100000000000000000", ->
    r = Rational.parseStr("1.23456789123456789")
    assert.equal r.toString(), "123456789123456789/100000000000000000"

  it "12345678912345678.9 -> 123456789123456789/10", ->
    r = Rational.parseStr("12345678912345678.9")
    assert.equal r.toString(), "123456789123456789/10"

  it "0..1 -> error", ->
    try
      r = Rational.parseStr("0..1")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: Error: '0..1'"

  it "a -> error", ->
    try
      r = Rational.parseStr("a")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: Error: 'a'"


  it "1 -> error", ->
    try
      r = Rational.parseStr("1", 1)
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '1' <= 1"

    try
      r = Rational.parseStr("1", "1")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '1' <= 1"

  it "37 -> error", ->
    try
      r = Rational.parseStr("1", 37)
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '37' >= 36"

    try
      r = Rational.parseStr("1", "37")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '37' >= 36"

  it "1.2 -> error", ->
    try
      r = Rational.parseStr("1", 1.2)
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '1.2' is not Integer"

    try
      r = Rational.parseStr("1", "1.2")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '1.2' is not Integer"

  it "1..2 -> error", ->
    try
      r = Rational.parseStr("1", "1..2")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: '1..2' is not Integer"

  it "a -> error", ->
    try
      r = Rational.parseStr("1", "a")
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.parseStr: Error: 'a'"
