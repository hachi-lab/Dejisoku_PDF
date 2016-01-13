require "prawn"
require "open-uri"
require 'rmagick'
require 'complex'

#画像の読込・サイズ測定と縮尺獲得
img = Magick::ImageList.new("1049.jpg")
$ws = img.columns
$hs = img.rows
$scale = 750.000 / $ws


#画像のオフセット表示
def offset_image(mv)
image "1049.jpg", :width => 750, :vposition => mv
$mvv = mv
end

#出力形式の作成

def plane
stroke_axis
stroke_circle [0,0] , 10

offset_image(0)

end

def kit
stroke_axis
stroke_circle [0,0] , 10

formatted_text_box [
{ :text => "Kyushu Institute of Technology", :styles => [:italic], :size => 30}
], :at => [50,50]
image (open "http://www.iizuka.kyutech.ac.jp/kit/wp-content/uploads/2014/01/logo021.jpg"), :height => 75, :at => [500,75]

offset_image(20)

end


#測定結果を出力するメソッド

def coordinate(mx,my,nx,ny)

#デジカメ計速の座標を圧縮拡大変換してPDF用の座標・距離を求める その他変数定義
mxx = mx * $scale
myy = (520 - $mvv) - (my * $scale)
nxx = nx * $scale
nyy = (520 - $mvv) - (ny * $scale)
fx = (mxx - nxx).abs
fy = (myy - nyy).abs
center_x = ((mxx + nxx) / 2)
center_y = ((myy + nyy) / 2)
distance = (Math.sqrt(fx ** 2 + fy ** 2)).round(1)
angle = Math.atan(fy / fx) * 180.0 / Math::PI
angle2 = 360 - (Math.atan(fy / fx) * 180.0 /Math::PI)
slope = (myy - nyy) / (mxx - nxx)
intercept = (nxx * myy - mxx * nyy) / (nxx - mxx)
origin_x = 375.0
origin_y = (520 - $mvv) - ($hs * $scale / 2)
value = 25
xxxxx = value * Math.cos(angle * Math::PI / 180)
yyyyy = value * Math.sin(angle * Math::PI / 180)


#描画

stroke_color "000000"
line [mxx,myy], [nxx,nyy]
stroke

fill_color "000000"
stroke_color "ffffff"

font_size(25) do
text_rendering_mode(:fill_stroke) do

if slope >= 0 then

if slope * origin_x + intercept > origin_y || (slope * origin_x + intercept <= origin_y && angle <= 45) then
draw_text(distance, :at => [center_x - xxxxx, center_y - yyyyy], :rotate => angle)
else
draw_text(distance, :at => [center_x + xxxxx, center_y + yyyyy], :rotate => angle + 180)
end

else

if slope * origin_x + intercept > origin_y || (slope * origin_x + intercept <= origin_y && angle <= 45) then
draw_text(distance, :at => [center_x - xxxxx, center_y + yyyyy], :rotate => angle2)
else
draw_text(distance, :at => [center_x - xxxxx, center_y + yyyyy], :rotate => angle2 + 180)
end

end

end

end

end


#PDFの生成，座標の描画，画像の貼り付け等

f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name,
:page_size => 'A4',
:page_layout => :landscape){

#出力形式の選択
case ARGV[0]
when "plane" then
plane
when "kit" then
kit
end


coordinate(1579,502,3586,770)
coordinate(3586,770,3519,1721)
coordinate(3519,1721,2791,1687)
coordinate(2791,1687,2732,2103)
coordinate(2732,2103,1416,1954)
coordinate(1416,1954,2347,914)
coordinate(2347,914,2479,929)
coordinate(2479,929,2459,1150)
coordinate(2459,1150,2325,1135)
coordinate(2325,1135,1579,502)

}
