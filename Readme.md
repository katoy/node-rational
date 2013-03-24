
This is fractopn library in coffee-script.

これは 分数、循環種数表記をサポートする有理数を扱う coffee-script のコードです。
(See also https://github.com/katoy/scala_rational )

travis: [![Build Status](https://travis-ci.org/katoy/node-rational.png?branch=master)](https://travis-ci.org/katoy/node-rational)

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

npm test では ./examples/sample-00.coffee が走る。
次のようにコンソールに出力されるはず。


    1/3
    0.{3}
    1/1
    1
    1/6
    0.1{6}
    1/3
    0.{3}
    0/1
    0
    3/10
    0.3
    3/10
    0.3
    1/3
    0.{3}
    1234567890123456789/1000000000000000000
    1.234567890123456789
    ---- class methods ----
    { [Function: Rational] parseFloat: [Function], parseStr: [Function] }
    ---- methods ----
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
    toRepeatString: [Function] }
									  
API
====
コンストラクタ：
- Rational(n, m)
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
- toRepeatString()


Developing
===========



    $ cake
    Cakefile defines the following tasks:
    
    cake build                # build coffee scripts into js
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

 
    $ coffee example/sample-01.coffee
	
Rational での四則演算の式の値を評価しています。
	

http://homepage2.nifty.com/youichi_kato/src/pegjs/expression/calcR_01.html  
テキストエリアに式を入れて ENTER キーを押すと、
値評価して、分数や小数(場合のよっては循環小数)で表示します。




