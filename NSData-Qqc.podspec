Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "NSData-Qqc"
  s.version      = "1.0.20"
  s.summary      = "NSData-Qqc"
  s.homepage     = "https://github.com/xukiki/NSData-Qqc"
  s.source       = { :git => "https://github.com/xukiki/NSData-Qqc.git", :tag => "#{s.version}" }
  
  s.source_files  = ["NSData-Qqc/*.{h,m}"]

end
