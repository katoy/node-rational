
This is fractopn library in coffee-script.

これは 分数、循環種数表記をサポートする有理数を扱う coffee-script のコードです。
(See also https://github.com/katoy/scala_rational )

travis: [![Build Status](https://travis-ci.org/katoy/node-rational.png?branch=master)](https://travis-ci.org/katoy/node-rational) [![Greenkeeper badge](https://badges.greenkeeper.io/katoy/node-rational.svg)](https://greenkeeper.io/)

インストール
============

    $ git clone https://github.com/katoy/node-rational.git
	$ npm install

動作チェック
=============

    $ npm test
	$ npm start

このライブリーでは循環種数は、繰り返し部分を {, } で囲んで表記します。  

例：
- 1/3 = 3.3333... は 0.{3}
- 1/6 = 0.166... は 0.1{6}

n 進数であることは _n を数字列の末尾に付けて示します。  

例
- 10_2  は 2 進数の 10
- 0.{3}_4 は 4 進数の 0.33333 ... 

2 .. 36 進数が扱えます。表記に使える文字は [0-9A-Z] の 36 文字です。

サンプル
=========
coffee ./examples/sample-00.coffee でサンプルコードが走ります。
次のようにコンソールに出力されるはずです。


    '1/2 - 1/3' = 1/6 = 0.1{6}
    '1/2 - 1/4' = 1/4 = 0.25
    '1 - 0.{9}' = 0/1 = 0
    '1 - 0.9' = 1/10 = 0.1
    '10_8 - 10_2' = 6/1 = 6
    '1/3' = 1/3 = 0.{3} = 0.1_3
    ---- arithmeticsR: class methods ----
    { parse: [Function],
      toSource: [Function],
      SyntaxError: [Function] }
    ---- arithmeticsR: methods ----
    undefined
    
    ---- Rational: class methods ----
    { [Function: Rational]
      toStringN: [Function],
      getRepeatString: [Function],
      getRepeatStringN: [Function],
      parseFloat: [Function],
      parseStr: [Function],
      getBigIntegerBaseN: [Function] }
    ---- Rational: methods ----
    { gratestCommonDiviser: [Function],
      numerator: [Function],
      denominator: [Function],
      add: [Function],
      sub: [Function],
      mul: [Function],
      div: [Function],
      neg: [Function],
      inv: [Function],
      compare: [Function],
      eq: [Function],
      lt: [Function],
      le: [Function],
      gt: [Function],
      ge: [Function],
      pow: [Function],
      floatValue: [Function],
      reduce: [Function],
      toString: [Function],
      toStringN: [Function],
      toRepeatString: [Function],
      toRepeatStringN: [Function] }
									  
API
====
コンストラクタ：
- Rational(n, m = 1)
- Rational(n)
- parseFloat(val)
- parseStr(str)

==== methods ====
- numerator()
- denominator()
- add(r)
- sub(r)
- mul(r)
- div(r)
- neg()
- inv()
- compare(r)
- eq(r)
- lt(r)
- le(r)
- gt:(r)
- ge(r)
- pow(n)
- floatValue()
- reduce()
- toString()
- toStringN(base = 10, show_base = true)
- toRepeatString()
- toRepeatStringN(base = 10, show_base = true)


Developing
===========


    $ cake
    Cakefile defines the following tasks:
    
    cake build                # all build
    cake build_rational       # build Rational.js 
    cake build_parser         # build parser
    cake build_browser        # build parser for browser
    cake lint                 # lint coffee scripts
    cake doc                  # generate documents
    cake clean:all            # clean pervious built js files and documents
    cake clean:js             # clean pervious built js files
    cake clean:doc            # clean pervious built documents
    cake test                 # do test
    cake coverage             # do coverage
    cake open_coverage        # open coverage report

サンプル
========

http://homepage2.nifty.com/youichi_kato/src/pegjs/expression/calcR_01.html  
テキストエリアに式を入れて ENTER キーを押すと、
値評価して、分数や小数(場合によっては循環小数)で表示します。


License
========

 - [MIT license](http://rem.mit-license.org/)
 - [MIT licemse 日本語訳](http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license) 

TODO:
=====

done: 10 進数だけでなく、n 進数 も扱えるようにすること。
 
