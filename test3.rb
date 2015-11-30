require "prawn"
require "open-uri"
#require 'fastimage'
require 'rmagick'

#p FastImage.size("http://stephensykes.com/images/ss.com_x.gif")
img = Magick::ImageList.new("1049.jpg")
ws = img.columns
hs = img.rows
$scale = 700.000 / ws
#puts sprintf("%.3f", $scale)

def coordinate(mx,my,nx,ny)
mxx = mx * $scale
myy = 550 - (my * $scale)
nxx = nx * $scale
nyy = 550 - (ny * $scale)

stroke_color 'ff0000'
line [mxx,myy], [nxx,nyy]
stroke
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

}
