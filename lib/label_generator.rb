require 'rmagick'
class LabelGenerator
  # TODO: CAN THESE THINGS BE MADE CONFIGURABLE? MABE FROM INITIALIZER?
  TMP_DIR = '/tmp'
  MAIN_MARGIN_QRCODE = 25
  FONT_POINT_SIZE_CODE128 = 7.5
  FONT_POINT_SIZE_QRCODE = 15

  def initialize(value, code, text = '')
    @value = value
    @code = code
    @text = text
    @tmp_file = "#{TMP_DIR}/#{@value}.png"
    @blob = nil
  end

  def to_png
    delete_tmp_file
    raise NoDataException if @blob.nil?

    @blob
  end

  private

  def write_tmp_file(content)
    File.open(@tmp_file, 'wb') { |f| f.write content }
  end

  def delete_tmp_file
    File.delete(@tmp_file) if File.exist?(@tmp_file)
  end

  # TODO: DECREASE CODE HERE 
  # return blob from super?
  def add_text_to_img(img_file, text, format, size)
    img = Magick::ImageList.new(img_file)
    draw = Magick::Draw.new
    img.annotate(draw, 0, 0, 0, 0, text) do
      draw.gravity = Magick::SouthGravity
      draw.pointsize = size
      draw.fill = '#000000'
      img.format = format
    end
    img.trim!
    img.border!(5, 5, 'white')
    img.to_blob
  end

  # TODO: HOW TO DEFINE THE MARGIN MORE GENERIC FOR POINT SIZES?
  def margin
    (MAIN_MARGIN_QRCODE + (@text.lines.count - 1) * FONT_POINT_SIZE_QRCODE)
  end

end
