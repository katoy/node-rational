Rational = require '../lib/Rational'
bignum = require 'bignum'

util = require 'util'

# 1/3 を定義する
r = new Rational(1, 3)
console.log r.toString()        #  "1/3"
console.log r.toRepeatString()  #  "0.{3}"

# 乗算、除算, 加算、減算
r = r.mul(3)
console.log r.toString()        #  "1/1"
console.log r.toRepeatString()  #  "1"

r = new Rational(1).div(6)
console.log r.toString()        #  "1/6"
console.log r.toRepeatString()  #  "0.1{6}"

r = r.add(r)
console.log r.toString()        #  "1/3"
console.log r.toRepeatString()  #  "0.{3}

r = r.sub(r)
console.log r.toString()        #  0/1
console.log r.toRepeatString()  #  0

# 数字、文字列から生成
r = Rational.parseFloat(0.3)
console.log r.toString()        #  "3/10"
console.log r.toRepeatString()  #  "0.3"

r = Rational.parseStr("0.3")
console.log r.toString()        #  "3/10"
console.log r.toRepeatString()  #  "0.3"

r = Rational.parseStr("0.{3}")
console.log r.toString()        #  "1/3"
console.log r.toRepeatString()  #  "0.{3}"

r = Rational.parseStr("1.234567890123456789")
console.log r.toString()        #  1234567890123456789/1000000000000000000
console.log r.toRepeatString()  # 1.234567890123456789

console.log "---- class methods ----"
console.log util.inspect(Rational, false, null)
console.log "---- methods ----"
console.log util.inspect(Rational.prototype, false, null)
