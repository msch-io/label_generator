require 'barby/outputter/rmagick_outputter'
require 'barby/outputter'
require 'rmagick'


# LICENSE
# Copyright (c) 2008 Tore Darell
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# WE OVERRIDE A SPECIFIC FUNCTION OF THIS BARBY OUTPUTTER
# CURRENTLY NOBODY SEEMS TO MAINTAIN BARBY

# THE FUNCTION to_image HAS A BUG WHICH IS GETS FIXED WITH THIS OVERRIDE HERE
# IF BARBY EVER GETS UPDATED AGAIN THIS MAY BE REMOVED FROM THIS GEM

class LabelGenerator
    module Helper
        class RmagickOutputterFixed < Barby::RmagickOutputter

            #Returns an instance of Magick::Image
            def to_image(opts={})
                with_options opts do
                b = background #Capture locally because Magick::Image.new block uses instance_eval
                # BUGFIX: ORIGINAL FUNCTION TRYS USING self.background_color WHICH IS A BUG
                canvas = Magick::Image.new(full_width, full_height){ self.background = b }
                bars = Magick::Draw.new
                bars.fill = foreground

                x1 = margin
                y1 = margin

                if barcode.two_dimensional?
                    encoding.each do |line|
                    line.split(//).map{|c| c == '1' }.each do |bar|
                        if bar
                        x2 = x1+(xdim-1)
                        y2 = y1+(ydim-1)
                        # For single pixels use point
                        if x1 == x2 && y1 == y2
                            bars.point(x1,y1)
                        else
                            # For single pixel lines, use line
                            if x1 == x2
                            bars.line(x1, y1, x1, y2)
                            elsif y1 == y2
                            bars.line(x1, y1, x2, y1)
                            else
                            bars.rectangle(x1, y1, x2, y2)
                            end
                        end
                        end
                        x1 += xdim
                    end
                    x1 = margin
                    y1 += ydim
                    end
                else
                    booleans.each do |bar|
                    if bar
                        x2 = x1+(xdim-1)
                        y2 = y1+(height-1)
                        # For single pixel width, use line
                        if x1 == x2
                        bars.line(x1, y1, x1, y2)
                        else
                        bars.rectangle(x1, y1, x2, y2)
                        end
                    end
                    x1 += xdim
                    end
                end

                bars.draw(canvas)

                canvas
                end
            end

        end
    end
end 