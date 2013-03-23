/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then computes their value.
 */

start
  = expression

expression
  = additive:additive { return additive; }

/** 左結合 **/
AdditiveOperator
 = operator:("+" / "-") { return operator; }

additive
  = head:multiplicative tail:( AdditiveOperator multiplicative ) * {
      var result = head;
      var len = tail.length;
      for (var i = 0; i < len; i++) {
        var op = tail[i][0];
        var val = tail[i][1];
        if (op == "+") {
          result = result.add(val);
        } else if (op == "-") {
          result = result.sub(val);
        }
      }
      return result;
    }

/** 左結合 **/
MultiplicativeOperator
 = operator:("*" / "/") { return operator; }

multiplicative
  = head:primary tail:(MultiplicativeOperator primary) * { 
      var result = head;
      var len = tail.length;
      for (var i = 0; i < len; i++) {
        var op = tail[i][0];
        if ("*" === op) {
          result = result.mul(tail[i][1]);
        } else if ("/" === op) {
          result = result.div(tail[i][1]);
        }
      }
      return result;
    }

sign
  = _ "-" { return "-"; }
  / _ "+"?  { return ""; }
 
primary
  = float
  / integer
  / sign:sign "(" additive:additive ")" _ {
      var ans = additive;
      if (sign === "-") {
        ans = ans.neg();
      }
      return ans;
    }

integer "integer"
  = sign:sign digits:[0-9]+ _ {
      return Rational.parseStr(sign + digits.join(""));
    }

float "float"
  = sign:sign parts:([0-9]* "." [0-9]* "{" [0-9]+ "}") _ {
      return Rational.parseStr(sign + parts[0].join("") + "." + parts[2].join("") + "{" + parts[4].join("") + "}");
    }
  / sign:sign parts:([0-9]* "." [0-9]+) _ {
      return Rational.parseStr(sign + parts[0].join("") + "." + parts[2].join(""));
    }

/* ===== Whitespace ===== */
_ "whitespace"
  = whitespace*

whitespace
  = [ \t\n\r]
