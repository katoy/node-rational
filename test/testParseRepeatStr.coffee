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

data = [
  ["1/1",  "1"],
  ["1/2",  "0.5"],
  ["1/3",  "0.{3}"],
  ["1/4",  "0.25"],
  ["1/5",  "0.2"],
  ["1/6",  "0.1{6}"],
  ["1/7",  "0.{142857}"],
  ["1/8",  "0.125"],
  ["1/9",  "0.{1}"],
  ["1/10",  "0.1"],
  ["1/11",  "0.{09}"],
  ["1/12",  "0.08{3}"],
  ["1/13",  "0.{076923}"],
  ["1/14",  "0.0{714285}"],
  ["1/15",  "0.0{6}"],
  ["1/16",  "0.0625"],
  ["1/17",  "0.{0588235294117647}"],
  ["1/18",  "0.0{5}"],
  ["1/19",  "0.{052631578947368421}"],
  ["1/20",  "0.05"],
  ["1/21",  "0.{047619}"],
  ["1/22",  "0.0{45}"],
  ["1/23",  "0.{0434782608695652173913}"],
  ["1/24",  "0.041{6}"],
  ["1/25",  "0.04"],
  ["1/26",  "0.0{384615}"],
  ["1/27",  "0.{037}"],
  ["1/28",  "0.03{571428}"],
  ["1/29",  "0.{0344827586206896551724137931}"],
  ["1/30",  "0.0{3}"],
  ["1/31",  "0.{032258064516129}"],
  ["1/32",  "0.03125"],
  ["1/33",  "0.{03}"],
  ["1/34",  "0.0{2941176470588235}"],
  ["1/35",  "0.0{285714}"],
  ["1/36",  "0.02{7}"],
  ["1/37",  "0.{027}"],
  ["1/38",  "0.0{263157894736842105}"],
  ["1/39",  "0.{025641}"],
  ["1/40",  "0.025"],
  ["1/41",  "0.{02439}"],
  ["1/42",  "0.0{238095}"],
  ["1/43",  "0.{023255813953488372093}"],
  ["1/44",  "0.02{27}"],
  ["1/45",  "0.0{2}"],
  ["1/46",  "0.0{2173913043478260869565}"],
  ["1/47",  "0.{0212765957446808510638297872340425531914893617}"],
  ["1/48",  "0.0208{3}"],
  ["1/49",  "0.{020408163265306122448979591836734693877551}"],
  ["1/50",  "0.02"],
  ["1/51",  "0.{0196078431372549}"],
  ["1/52",  "0.01{923076}"],
  ["1/53",  "0.{0188679245283}"],
  ["1/54",  "0.0{185}"],
  ["1/55",  "0.0{18}"],
  ["1/56",  "0.017{857142}"],
  ["1/57",  "0.{017543859649122807}"],
  ["1/58",  "0.0{1724137931034482758620689655}"],
  ["1/59",  "0.{0169491525423728813559322033898305084745762711864406779661}"],
  ["1/60",  "0.01{6}"],
  ["1/61",  "0.{016393442622950819672131147540983606557377049180327868852459}"],
  ["1/62",  "0.0{161290322580645}"],
  ["1/63",  "0.{015873}"],
  ["1/64",  "0.015625"],
  ["1/65",  "0.0{153846}"],
  ["1/66",  "0.0{15}"],
  ["1/67",  "0.{014925373134328358208955223880597}"],
  ["1/68",  "0.01{4705882352941176}"],
  ["1/69",  "0.{0144927536231884057971}"],
  ["1/70",  "0.0{142857}"],
  ["1/71",  "0.{01408450704225352112676056338028169}"],
  ["1/72",  "0.013{8}"],
  ["1/73",  "0.{01369863}"],
  ["1/74",  "0.0{135}"],
  ["1/75",  "0.01{3}"],
  ["1/76",  "0.01{315789473684210526}"],
  ["1/77",  "0.{012987}"],
  ["1/78",  "0.0{128205}"],
  ["1/79",  "0.{0126582278481}"],
  ["1/80",  "0.0125"],
  ["1/81",  "0.{012345679}"],
  ["1/82",  "0.0{12195}"],
  ["1/83",  "0.{01204819277108433734939759036144578313253}"],
  ["1/84",  "0.01{190476}"],
  ["1/85",  "0.0{1176470588235294}"],
  ["1/86",  "0.0{116279069767441860465}"],
  ["1/87",  "0.{0114942528735632183908045977}"],
  ["1/88",  "0.011{36}"],
  ["1/89",  "0.{01123595505617977528089887640449438202247191}"],
  ["1/90",  "0.0{1}"],
  ["1/91",  "0.{010989}"],
  ["1/92",  "0.01{0869565217391304347826}"],
  ["1/93",  "0.{010752688172043}"],
  ["1/94",  "0.0{1063829787234042553191489361702127659574468085}"],
  ["1/95",  "0.0{105263157894736842}"],
  ["1/96",  "0.01041{6}"],
  ["1/97",  "0.{010309278350515463917525773195876288659793814432989690721649484536082474226804123711340206185567}"],
  ["1/98",  "0.0{102040816326530612244897959183673469387755}"],
  ["1/99",  "0.{01}"],
  ["1/100",  "0.01"]
]

describe "pareStr_repeat", ->
  it "1/n ->小数 (n in [1..100])", ->
    for d in [1..100]
      r = new Rational(1).div(d)
      assert.equal r.toRepeatString(), data[d-1][1]

  it "小数 -> 分数 (1/n, n in [1..100])", ->
    for d in [1..100]
      r = Rational.parseStr(data[d-1][1])
      assert.equal "#{r.numerator()}/#{r.denominator()}", data[d-1][0]

