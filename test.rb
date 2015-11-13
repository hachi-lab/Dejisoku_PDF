require "prawn"
require 'date'

f_name = File.basename(__FILE__, ".rb")+".pdf"

t = Time.now

Prawn::Document.generate(f_name) {

stroke_axis
stroke_circle [0,0] , 10 #原点

text "Test", :size => 25

# 線の描画
stroke do
 # just lower the current y position
 move_down 50
 horizontal_rule
 vertical_line 100, 300, :at => 50
 horizontal_line 200, 500, :at => 150
end

#箱の中に現在時刻を表示
bounding_box([100,300],:width=>100,:height=>100   ){

	stroke_bounds
	stroke_circle [0,0] , 10 # ボックス右下原点の相対座標になる
	text "Current time is", :color => "FF0000"
	text "#{t}"
}


#図形の描画
pentagram = [[181, 395], [0, 336], [111, 490], [111,300], [0, 454]]
stroke_color 'ff0000'
line_width 2
text_box "Nonzero Winding Number", :at => [50, 715],
 :width => 170,
 :align => :center
polygon(*pentagram.map { |x, y| [x + 50, y] })
fill_and_stroke
text_box "Even-Odd", :at => [330, 715], :width => 170, :align => :center
polygon(*pentagram.map { |x, y| [x + 330, y] })
fill_and_stroke(:fill_rule => :even_odd)

}


