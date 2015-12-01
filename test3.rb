require "prawn"
require "open-uri"
require 'rmagick'
require 'complex'

#画像の読込・サイズ測定と縮尺獲得
img = Magick::ImageList.new("1049.jpg")
ws = img.columns
hs = img.rows
$scale = 700.000 / ws


#測定結果を出力するメソッド

def coordinate(mx,my,nx,ny)

#デジカメ計速の座標を圧縮拡大変換してPDF用の座標・距離を求める
mxx = mx * $scale
myy = 525 - (my * $scale)
nxx = nx * $scale
nyy = 525 - (ny * $scale)
center_x = (mxx+nxx)/2
center_y = (myy+nyy)/2
distance = Math.sqrt((((mxx-nxx).abs) ** 2 + ((myy-nyy).abs) ** 2))


#描画

line [mxx,myy], [nxx,nyy]
stroke
draw_text distance, :at => [center_x, center_y]

end


f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name,
:page_size => 'A4',
:page_layout => :landscape){
stroke_axis
stroke_circle [0,0] , 10


#text "1049"
#image (open "https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG"), :width => 500

image "1049.jpg", :width => 700

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
