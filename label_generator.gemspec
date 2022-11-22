Gem::Specification.new do |s|
  # general information
  s.name                   = 'label_generator'
  s.version                = '0.1.0'
  s.licenses               = ['MIT']
  s.summary                = "Generate lables in different types and formats!"
  s.description            = "????"
  s.authors                = ["Maximilian Schumacher"]
  s.homepage               = 'https://rubygems.org/gems/label_generator'

  s.files                  = ["lib/label_generator.rb",
                              "lib/label_generator/code128.rb",
                              "lib/label_generator/qrcode.rb",
                              "lib/label_generator/helper/rmagick_outputter_fixed.rb"]
  # requirements
  s.required_ruby_version  = '>= 2.7.0'

  s.requirements          << 'libmagick, v6.0'

  s.add_runtime_dependency   'rmagick', '~> 5'
  s.add_runtime_dependency   'barby', '~> 0.6'
  s.add_runtime_dependency   'rqrcode', '~> 0.10'

  s.metadata               = { "source_code_uri" => "https://github.com/msch-io/label_generator" }
end
