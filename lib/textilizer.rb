class Textilizer
  def initialize(text)
    @text = text
  end
  
  def to_html
    RedCloth.new(formatted_text).to_html
  end
  
  def formatted_text
    @text.gsub(/^@@@ ?(\w*)\r?\n(.+?)\r?\n@@@\r?$/m) do |match|
      lang = $2.empty? ? nil : $1
      "\n<notextile>" + CodeRay.scan($3, lang).div(:css => :class) + "</notextile>"
    end
  end
end