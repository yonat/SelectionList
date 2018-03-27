
Pod::Spec.new do |s|

  s.name         = "SelectionList"
  s.version      = "1.0"
  s.summary      = "Simple single-selection or multiple-selection view, based on UITableView."

  s.homepage     = "https://github.com/yonat/SelectionList"
  s.screenshots  = "https://raw.githubusercontent.com/yonat/SelectionList/master/Screenshots/SelectionList.png"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }

  s.author             = { "Yonat Sharon" => "yonat@ootips.org" }
  s.social_media_url   = "http://twitter.com/yonatsharon"

  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/yonat/SelectionList.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"

end
