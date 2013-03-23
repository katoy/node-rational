arithmeticsR = require '../lib/arithmeticsR'

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

console.log "---- arithmeticsR: class methods ----"
console.log util.inspect(arithmeticsR, false, null)
console.log "---- arithmeticsR: methods ----"
console.log util.inspect(arithmeticsR.prototype, false, null)
