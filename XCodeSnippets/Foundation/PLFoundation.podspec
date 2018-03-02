
Pod::Spec.new do |s|

  s.name         = "PLFoundation"
  s.version      = "0.0.1"
  s.summary      = "Foundation: 工具库"

  s.description  = <<-DESC
		工具库：通过pod管理，控制耦合度
                   DESC

  s.homepage     = "https://github.com/zhu410289616"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "zhu410289616" => "zhu410289616@163.com" }
  # s.platform     = :ios
  s.platform     = :osx, "10.11"

  s.source       = { :git => "https://github.com/zhu410289616", :tag => s.version.to_s }

  s.default_subspec = "Foundation" 

  s.subspec "Foundation" do |cs|
    cs.source_files  = "Classes", "Classes/Category/*.{h,m}"
    cs.requires_arc = true
  end

end
