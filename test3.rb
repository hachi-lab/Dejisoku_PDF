require "prawn"
require "open-uri"
require "fastimage"

i_size = FastImage.size("https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG")

f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name) {
stroke_axis
stroke_circle [0,0] , 10

text "Matz"
image (open "https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG"), :width => 200

#image "Matz.jpg", :width => 500

stroke_color 'ff0000'

stroke do
 # just lower the current y position
 horizontal_rule
 vertical_line 100, 500, :at => 50
 horizontal_line 200, 500, :at => 400
end

}
