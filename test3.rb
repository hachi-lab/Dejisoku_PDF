require "prawn"
require "open-uri"
#require 'fastimage'
require 'rmagick'

#p FastImage.size("http://stephensykes.com/images/ss.com_x.gif")
img = Magick::ImageList.new("1049.jpg")
p ws = img.columns
p hs = img.rows
scale = 700.000 / ws
puts sprintf("%.3f", scale)

mx = 1705
my = 1070
nx = 1597
ny = 1049

mxx = mx * scale
myy = 550 - (my * scale)
nxx = nx * scale
nyy = 550 - (ny * scale)

f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name,
:page_size => 'A4',
:page_layout => :landscape){
stroke_axis
stroke_circle [0,0] , 10


#text "1049"
#image (open "https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG"), :width => 500

image "1049.jpg", :width => 700

stroke_color 'ff0000'

line [mxx,myy], [nxx,nyy]
stroke

}
