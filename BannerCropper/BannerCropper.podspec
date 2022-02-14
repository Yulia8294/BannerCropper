Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "BannerCropper"
s.summary = "Banner Cropper is a controller for editing image for use as a banner"
s.requires_arc = true

s.version = "0.1.4"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Yulia Novikova" => "elenn1156@gmail.com" }

s.homepage = "https://github.com/Yulia8294/BannerCropper"

s.source = { :git => "https://github.com/Yulia8294/BannerCropper.git", 
             :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "BannerCropper/**/*.{swift}"

s.resources = "BannerCropper/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "5.0"

end
