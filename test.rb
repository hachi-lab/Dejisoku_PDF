require "prawn"

# Assignment
pdf = Prawn::Document.new
pdf.text "Hello World"
pdf.render_file "assignment.pdf"
# Implicit Block
Prawn::Document.generate("implicit.pdf") do
 text "Hello World"
end
# Explicit Block
Prawn::Document.generate("explicit.pdf") do |pdf|
 pdf.text "Hello World"
end

