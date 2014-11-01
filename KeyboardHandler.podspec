Pod::Spec.new do |s|
  s.name         = "KeyboardHandler"
  s.version      = "0.0.1"
  s.summary      = "A tool helps you handle with keybord on iOS."
  s.homepage     = "https://github.com/p581581/KeyboardHandler"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Boyi Wu" => "p581581@gmail.com" }
  s.source       = { 
                     :git => "https://github.com/p581581/KeyboardHandler.git",
                     :tag => "0.0.1"
                   }
  s.source_files = 'KeyboardHandler/KeyboardHandler.{h,m}'
  s.framework  = 'UIKit'
  s.requires_arc = true
  s.platform     = :ios, '7.0'
end
