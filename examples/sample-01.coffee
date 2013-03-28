arithmeticsR = require '../lib/arithmeticsR'
Rational = require '../lib/Rational'

util = require 'util'

exp = "1/2 - 1/3"
r = arithmeticsR.parse(exp)
console.log "'#{exp}' = #{r} = #{r.toRepeatString()}"

exp = "1/2 - 1/4"
r = arithmeticsR.parse(exp)
console.log "'#{exp}' = #{r} = #{r.toRepeatString()}"

exp = "1 - 0.{9}"
r = arithmeticsR.parse(exp)
console.log "'#{exp}' = #{r} = #{r.toRepeatString()}"

exp = "1 - 0.9"
r = arithmeticsR.parse(exp)
console.log "'#{exp}' = #{r} = #{r.toRepeatString()}"

exp = "10_8 - 10_2"
r = arithmeticsR.parse(exp)
console.log "'#{exp}' = #{r} = #{r.toRepeatString()}"

exp = "1/3"
r = arithmeticsR.parse(exp)
console.log "'#{exp}' = #{r} = #{r.toRepeatString()} = #{r.toRepeatStringN(3)}"


console.log "---- arithmeticsR: class methods ----"
console.log util.inspect(arithmeticsR, false, null)
console.log "---- arithmeticsR: methods ----"
console.log util.inspect(arithmeticsR.prototype, false, null)

console.log ""
console.log "---- Rational: class methods ----"
console.log util.inspect(Rational, false, null)
console.log "---- Rational: methods ----"
console.log util.inspect(Rational.prototype, false, null)

