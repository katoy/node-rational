assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/arithmetidcsR' else  'lib/arithmeticsR'
libPath = path.join __dirname, '..', libPath
arithmeticsR = require libPath

Rational = require '../lib/Rational'

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "arithmeticsR.parse 整数", ->
  it "(10_2)", ->
    r = arithmeticsR.parse("10_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "2, 1"
    assert.equal r.reduce().toRepeatString(), "2"

  it "(0_2)", ->
    r = arithmeticsR.parse("0_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

  it "(-10_2)", ->
    r = arithmeticsR.parse("-10_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-2, 1"
    assert.equal r.reduce().toRepeatString(), "-2"

  it "(10_8)", ->
    r = arithmeticsR.parse("10_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "8, 1"
    assert.equal r.reduce().toRepeatString(), "8"

  it "(-10_8)", ->
    r = arithmeticsR.parse("-10_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-8, 1"
    assert.equal r.reduce().toRepeatString(), "-8"

  it "(12345670123456701234567_8)", ->
    r = arithmeticsR.parse("123456701234567012345670_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "770996035962450594744, 1"
    assert.equal r.reduce().toRepeatString(), "770996035962450594744"

  it "(-123456701234567012345670_8)", ->
    r = arithmeticsR.parse("-123456701234567012345670_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-770996035962450594744, 1"
    assert.equal r.reduce().toRepeatString(), "-770996035962450594744"

describe "arithmeticsR.parse 小数", ->
  it "(0.3_4) -> ", ->
    r = arithmeticsR.parse("0.3_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 4"
    assert.equal r.reduce().toRepeatString(), "0.75"

  it "(0.0_4)", ->
    r = arithmeticsR.parse("0.0_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

  it "(-0.3_4)", ->
    r = arithmeticsR.parse("-0.3_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 4"
    assert.equal r.reduce().toRepeatString(), "-0.75"

  it "(1.3_4)", ->
    r = arithmeticsR.parse("1.3_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 4"
    assert.equal r.reduce().toRepeatString(), "1.75"

  it "(1.2_4)", ->
    r = arithmeticsR.parse("1.2_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 2"
    assert.equal r.reduce().toRepeatString(), "1.5"

  it "(1.23012301230_4)", ->
    r = arithmeticsR.parse("1.23012301230_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1776411, 1048576"
    assert.equal r.reduce().toRepeatString(), "1.69411754608154296875"

  it "(-1.23012301230_4)", ->
    r = arithmeticsR.parse("-1.23012301230_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1776411, 1048576"
    assert.equal r.reduce().toRepeatString(), "-1.69411754608154296875"

describe "arithmeticsR.parse 循環小数", ->
  it "(0.{3}_5)", ->
    r = arithmeticsR.parse("0.{3}_5")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 4"
    assert.equal r.reduce().toRepeatString(), "0.75"

  it "(0.{0}_4)", ->
    r = arithmeticsR.parse("0.{0}_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

  it "(-0.{3}_5)", ->
    r = arithmeticsR.parse("-0.{3}_5")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 4"
    assert.equal r.reduce().toRepeatString(), "-0.75"

  it "(0.{123}_4)", ->
    r = arithmeticsR.parse("0.{123}_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 7"
    assert.equal r.reduce().toRepeatString(), "0.{428571}"

  it "(-0.{123}_4)", ->
    r = arithmeticsR.parse("-0.{123}_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 7"
    assert.equal r.reduce().toRepeatString(), "-0.{428571}"

  it "(0.{12}_4)", ->
    r = arithmeticsR.parse("0.{12}_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "2, 5"
    assert.equal r.reduce().toRepeatString(), "0.4"

describe "arithmeticsR.parse 加法,減法", ->
  it "(0.{3}_8 + 0.{6}_8)", ->
    r = arithmeticsR.parse("0.{3}_8 + 0.{6}_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 7"
    assert.equal r.reduce().toRepeatString(), "1.{285714}"

  it "(0.3_8 + 0.6_8)", ->
    r = arithmeticsR.parse("0.3_8 + 0.6_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 8"
    assert.equal r.reduce().toRepeatString(), "1.125"

  it "(0.{3}_8 - 0.{6}_8)", ->
    r = arithmeticsR.parse("0.{3}_8 - 0.{6}_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 7"
    assert.equal r.reduce().toRepeatString(), "-0.{428571}"

  it "(0.3_8 - 0.6_8)", ->
    r = arithmeticsR.parse("0.3_8 - 0.6_8")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 8"
    assert.equal r.reduce().toRepeatString(), "-0.375"

  it "(1_2 + 10_2 + 11_2 + 100_2 - 101_2 - 101_2)", ->
    r = arithmeticsR.parse("1_2 + 10_2 + 11_2 + 100_2 - 101_2 - 101_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

describe "arithmeticsR.parse 載法, 除法", ->
  it "(0.{3}_4 * 3_4)", ->
    r = arithmeticsR.parse("0.{3}_4 * 3_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 1"
    assert.equal r.reduce().toRepeatString(), "3"

  it "(0.3_4 * 3_4)", ->
    r = arithmeticsR.parse("0.3 * 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 10"
    assert.equal r.reduce().toRepeatString(), "0.9"

  it "(0.{3}_4 / 3_4)", ->
    r = arithmeticsR.parse("0.{3}_4 / 3_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.reduce().toRepeatString(), "0.{3}"

  it "(0.3_4 / 3_4)", ->
    r = arithmeticsR.parse("0.3_4 / 3_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 4"
    assert.equal r.reduce().toRepeatString(), "0.25"

  it "(3_4 * 11_4 / 20_4 * 12_4)", ->
    r = arithmeticsR.parse("3_4 * 11_4 / 20_4 * 12_4")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "45, 4"
    assert.equal r.reduce().toRepeatString(), "11.25"

describe "arithmeticsR.parse 演算の優先度", ->
  it "(1_2 + 10_2 * 11_2)", ->
    r = arithmeticsR.parse("1_2 + 10_2 * 11_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 1"
    assert.equal r.reduce().toRepeatString(), "7"

  it "(1_2 + 10_2) * 11_2)", ->
    r = arithmeticsR.parse("(1_2 + 10_2) * 11_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 1"
    assert.equal r.reduce().toRepeatString(), "9"

describe "Space ", ->
  it "(1_2+10_2*11_2)", ->
    r = arithmeticsR.parse("1_2+10_2*11_2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 1"
    assert.equal r.reduce().toRepeatString(), "7"

  it "(1_2 + 10_2 * 11_2)", ->
    r = arithmeticsR.parse(" 1_2 + 10_2 * 11_2 ")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 1"
    assert.equal r.reduce().toRepeatString(), "7"

  it "(1_2 + 10_8 * 11_2)", ->
    r = arithmeticsR.parse(" 1_2 + 10_8 * 11_2 ")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "25, 1"
    assert.equal r.reduce().toRepeatString(), "25"


