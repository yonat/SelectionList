
Pod::Spec.new do |s|

  s.name         = "SelectionList"
  s.version      = "1.4.4"
  s.summary      = "Simple single-selection or multiple-selection checklist, based on UITableView."

  s.homepage     = "https://github.com/yonat/SelectionList"
  s.screenshots  = "https://raw.githubusercontent.com/yonat/SelectionList/master/Screenshots/SelectionList.png"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }

  s.author             = { "Yonat Sharon" => "yonat@ootips.org" }

  s.swift_version = '4.2'
  s.swift_versions = ['4.2', '5.0']
  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/yonat/SelectionList.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.resource_bundles = {s.name => ['PrivacyInfo.xcprivacy']}

  s.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '$(FRAMEWORK_SEARCH_PATHS)' } # fix Interface Builder render error

end
