Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "BannerCropper"
s.summary = "Banner Cropper is a controller for editing image for use as a banner"
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Yulia Novikova" => "elenn1156@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/Yulia8294/BannerCropper"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/Yulia8294/BannerCropper.git", 
             :tag => "#{s.version}" }

s.framework = "UIKit"

s.source_files = "BannerCropper/**/*.{swift}"

s.resources = "BannerCropper/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

s.swift_version = "5.0"

end
