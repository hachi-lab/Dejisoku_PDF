require "prawn"
require "open-uri"

f_name = File.basename(__FILE__, ".rb")+".pdf"
Prawn::Document.generate(f_name) {
#stroke_axis

text "Matz"
image open "http://www.prometric-jp.com/career/img/pho_20101020_01.jpg"

}
