require "prawn"
require "open-uri"
#require 'fastimage'
require 'rmagick'

#p FastImage.size("http://stephensykes.com/images/ss.com_x.gif")
img = Magick::ImageList.new("https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG")
p ws = img.columns
p hs = img.rows
puts sprintf("%.3f", 500.000 / ws)

f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name,
:page_size => 'A4',
:page_layout => :landscape){
stroke_axis
stroke_circle [0,0] , 10


text "1049"
#image (open "https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG"), :width => 500

image "1049.jpg", :width => 500

stroke_color 'ff0000'

stroke do
 # just lower the current y position
 horizontal_rule
 vertical_line 100, 500, :at => 50
 horizontal_line 200, 500, :at => 400
end

}
