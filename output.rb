require 'prawn'
require 'open-uri'
require 'rmagick'
require 'complex'
require 'json'
require 'rest_client'
include Magick

#デジカメ計速のAPIとアカウント指定
$api_server = 'http://api2.dc-keisoku.com'
$username = 'tanaka_lab'
$password = 'pass'
$project_id = 545
$image_id = 1538

#ログイン
puts '=== /user/login'
$key = RestClient.post("#{$api_server}/user/login",
username: $username, 
password: $password)

#プロジェクト一覧の取得
puts '=== /project/list'
ret = RestClient.post("#{$api_server}/project/list",
key: $key)
projects = JSON.parse(ret)

#画像のURLを取得
puts '=== /project/images'
ret = RestClient.post("#{$api_server}/project/images",
key: $key,
project_id: $project_id)
images = JSON.parse(ret)

imagelist = []
images.each do |image|
url = RestClient.post("#{$api_server}/image/image_url",
key: $key,
image_id: image["id"])
imagelist << {id: image["id"], url: url}
end

puts $gazo = imagelist[0][:url]

#点と線の情報を取得
puts '=== /point/get_line_all_detail'
ret = RestClient.post("#{$api_server}/point/get_line_all_detail",
key: $key,
image_id: $image_id)
line_info = JSON.parse(ret)
line_list = []
i = 0
line_info.each do |linf|
line_list[i] = [linf[1][1],linf[1][2],linf[2][1],linf[2][2],linf[3]]
i += 1
end

line_list.each do |h|
p h
end


#画像の読込・サイズ測定と縮尺獲得
img = ImageList.new("1049.jpg")
puts $ws = img.columns
puts $hs = img.rows
$scale = 750.000 / $ws


#画像のオフセット表示
def offset_image(mv)
image (open $gazo), :width => 750, :vposition => mv
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


#描画情報

def dot_specific(mx,my,nx,ny,len)

#デジカメ計速の座標を圧縮拡大変換してPDF用の座標・距離を求める その他変数定義
mxx = mx * $scale
myy = (525 - $mvv) - (my * $scale)
nxx = nx * $scale
nyy = (525 - $mvv) - (ny * $scale)
fx = (mxx - nxx).abs
fy = (myy - nyy).abs
center_x = ((mxx + nxx) / 2)
center_y = ((myy + nyy) / 2)
#distance = (Math.sqrt(fx ** 2 + fy ** 2)).round(1)
distance = len
angle = Math.atan(fy / fx) * 180.0 / Math::PI
angle2 = 360 - (Math.atan(fy / fx) * 180.0 /Math::PI)
slope = (myy - nyy) / (mxx - nxx)
intercept = (nxx * myy - mxx * nyy) / (nxx - mxx)
origin_x = 375.0
origin_y = (525 - $mvv) - ($hs * $scale / 2)
value = 25
xxxxx = value * Math.cos(angle * Math::PI / 180)
yyyyy = value * Math.sin(angle * Math::PI / 180)
sxa = center_x - xxxxx
sya = center_y - yyyyy
sxb = center_x + xxxxx
syb = center_y + yyyyy

#描画始点を求める

winfo = []

if slope >= 0 then

if slope * origin_x + intercept > origin_y || (slope * origin_x + intercept <= origin_y && angle <= 45) then
winfo << sxa.round << sya.round << angle.round << len
else
angle = angle + 180
winfo << sxb.round << syb.round << angle.round << len
end

else

if slope * origin_x + intercept > origin_y || (slope * origin_x + intercept <= origin_y && angle <= 45) then
winfo << sxa.round << syb.round << angle2.round << len
else
angle2 = angle2 + 180
winfo << sxa.round << syb.round << angle2.round << len
end

end

#描画四点を求める

ry1 = 34 * Math.sin(winfo[2])
ry2 = 34 * Math.cos(winfo[2])
ry3 = 85 * Math.sin(winfo[2])
ry4 = 85 * Math.cos(winfo[2])

dot1 = []
dot2 = []
dot3 = []
dot4 = []

dot1 = [winfo[0].round, winfo[1].round]
dot2 = [(-ry1 + winfo[0]).round, (ry2 + winfo[1]).round]
dot3 = [(ry4 - ry1 + winfo[0]).round, (ry3 + ry2 + winfo[1]).round]
dot4 = [(ry4 + winfo[0]).round, (ry3 + winfo[1]).round]

dinfo = []
dinfo = [dot1, dot2, dot3, dot4]

return [winfo, dinfo]

end


#判定（線分）

def decision(ax, ay, bx, by, cx, cy, dx, dy)

i = 0

ans1 = (ax - bx) * (cy - ay) + (ay - by) * (ax - cy)
ans2 = (ax - bx) * (dy - ay) + (ay - by) * (ax - dy)

ans3 = (cx - dx) * (ay - cy) + (cy - dy) * (cx - ay)
ans4 = (cx - dx) * (by - cy) + (cy - dy) * (cx - by)

if ((ans1 >= 0 && ans2 <= 0) || (ans1 <= 0 && ans2 >= 0)) && ((ans3 >= 0 && ans4 <= 0) || (ans3 <= 0 && ans4 >= 0)) then

return 0

else

return 1

end
end


#判定(文字）
def judgement

h = 0
i = 0

jbox = []

fac = $dot_list.length
numbers = []
g = 0

fac.times do
numbers << g
g = g + 1
end

cbox =[]

numbers.combination(2) {|j,k|
cbox << j << k
}
cbox = cbox.each_slice(2).to_a

numbers.combination(2) {|j,k|

4.times do
if h <= 2 then

4.times do
if i <= 2 then
jbox << decision($dot_list[j][h][0], $dot_list[j][h][0], $dot_list[j][h + 1][0], $dot_list[j][h + 1][1], $dot_list[k][i][0], $dot_list[k][i][1], $dot_list[k][i + 1][0], $dot_list[k][i + 1][1])
i = i + 1
else
jbox << decision($dot_list[j][h][0], $dot_list[j][h][0], $dot_list[j][h + 1][0], $dot_list[j][h + 1][1], $dot_list[k][i][0], $dot_list[k][i][1], $dot_list[k][0][0], $dot_list[k][0][1])
end
end

h = h + 1
i = 0

else

4.times do
if i <= 2 then
jbox << decision($dot_list[j][h][0], $dot_list[j][h][0], $dot_list[j][0][0], $dot_list[j][0][1], $dot_list[k][i][0], $dot_list[k][i][1], $dot_list[k][i + 1][0], $dot_list[k][i + 1][1])
i = i + 1
else
jbox << decision($dot_list[j][h][0], $dot_list[j][h][0], $dot_list[j][0][0], $dot_list[j][0][1], $dot_list[k][i][0], $dot_list[k][i][1], $dot_list[k][0][0], $dot_list[k][0][1])
end
end
end

end

}

jbox = jbox.each_slice(16).to_a

jbox2 = []

jbox.each do |list|
jbox2 << list.inject {|kake, n| kake * n }
end

m = 0
jbox2.each do |list|
if list == 0 then
p cbox[m]
end
m = m + 1
end

end


#描画

def coordinate(x, y, deg, len)

stroke_color "000000"
#line [mxx,myy], [nxx,nyy]
stroke

fill_color "000000"
stroke_color "ffffff"

font_size(25.5) do
text_rendering_mode(:fill_stroke) do

draw_text(len, :at => [x, y], :rotate => deg)

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


#描画座標情報を格納

$dot_list = []

line_list.each do |list|
$dot_list << dot_specific(list[0],list[1],list[2],list[3],list[4])[1]
end

$dot_list.each do |list|
p list
end

judgement

info_box = []
line_list.each do |list|
info_box << dot_specific(list[0],list[1],list[2],list[3],list[4])[0]
end

p info_box

info_box.each do |list|
coordinate(list[0],list[1],list[2],list[3])
end

}
