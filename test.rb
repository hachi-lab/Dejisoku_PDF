require "prawn"
require 'date'

f_name = File.basename(__FILE__, ".rb")+".pdf"

t = Time.now

Prawn::Document.generate(f_name) {

stroke_axis
stroke_circle [0,0] , 10 #原点

text "Time now"

bounding_box([100,300],:width=>100,:height=>100   ){

	stroke_bounds
	stroke_circle [0,0] , 10 # ボックス右下原点の相対座標になる
	text "#{t}"
}
}


