require 'barby'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

class LabelGenerator

    # TODO: ADD FUNCTION TO ADD PICTURE TO QRCODE PNG
    # CAN THE SIZING BE MORE DYNAMIC?
    class QRCode < LabelGenerator
  
      def initialize(value, text = '', level = :q, xdim = 4)
        @xdim = xdim
        code = Barby::QrCode.new(value, level: level, size: @xdim)

        super(value, code, text)
      end
  
      def to_png
        outputter = Barby::PngOutputter.new(@code)
        code_png = outputter.to_png(margin: self.margin, xdim: @xdim)
        if @text.empty?
          @blob = code_png
        else
          write_tmp_file(code_png)
          @blob = self.add_text_to_img(@tmp_file, @text, 'png', FONT_POINT_SIZE_QRCODE)
        end

        super
      end

      # TODO: IMPLEMENT add_text_to_img function
  
    end
  end