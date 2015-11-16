require "prawn"
require "open-uri"

f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name) {
#stroke_axis

text "Matz"
#image open "https://upload.wikimedia.org/wikipedia/commons/7/76/Yukihiro_Matsumoto.JPG"

image "Matz.jpg", :at => [0, 0]

}
