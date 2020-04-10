Pod::Spec.new do |s|
  s.name         = "Source"
  s.version      = "0.0.1"
  s.platform     = :ios, '8.0'
  s.summary      = "Core"
  s.homepage     = "git@Source"
  s.description  = <<-DESC
                    #Core
                    DESC
  s.license      = {
    :type => '58license',
    :text => <<-LICENSE
    LICENSE
  }
  s.source       = { :git => "https://", :tag => "#{s.version}" }
  s.authors      = { "Sac"=>"zdl51go@gmail.com"}
  s.source_files = '**/*.{h,m,mm,c,cc,cpp}'
  s.resources = '**/*.{xcassets,bundle,json,strings,xib,plist}'
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
  s.requires_arc = true
  s.xcconfig = {
    "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2"
  }


  s.dependency 'MagpieBridge'

end
