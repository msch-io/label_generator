require 'barby'
require 'barby/barcode/code_128'
require 'label_generator/helper/rmagick_outputter_fixed'

class LabelGenerator
    class Code128 < LabelGenerator
  
      def initialize(value, text = value, xdim = 10, height = 80)
        code = Barby::Code128.new(value)
        @xdim = xdim
        @height = height

        super(value, code, text)
      end
  
      def to_png
        outputter = LabelGenerator::Helper::RmagickOutputterFixed.new(@code)
        code_img = outputter.to_image(margin: self.margin, xdim: @xdim, height: @height)
        if @text.empty?
          @blob = code_img.to_png
        else
          @blob = self.add_text_to_img(code_img, @text, 'png', FONT_POINT_SIZE_CODE128)
        end

        super
      end

      # TODO: USER SUPER
      def add_text_to_img(bc, text, format, size)
        textimg = Magick::Image.new(bc.columns, (size*10))
        draw = Magick::Draw.new
        textimg.annotate(draw, 0, 0, 0, 0, text) do
          draw.gravity = Magick::SouthGravity
          draw.pointsize = size
          draw.density = "300x300"
          draw.fill = '#000000'
          textimg.format = format
        end
  
        bc.format = format
        bc.density = "300x300"
        bc.crop!(0, 0, bc.columns, 80)
  
        image_list = Magick::ImageList.new
        image_list.push(bc)
        image_list.push(textimg)
        image_list.append(true).to_blob
      end
  
    end
  end