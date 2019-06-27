Pod::Spec.new do |s|
  s.name             = 'Chausie'
  s.version          = '0.1.2'
  s.summary          = 'Chausie provides a customizable view containers that manages navigation between pages of content. :cat:'
  s.homepage         = 'https://github.com/cats-oss/Chausie'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shoheiyokoyama' => 'shohei.yok0602@gmail.com' }
  s.source           = { :git => 'https://github.com/cats-oss/Chausie.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'Chausie/**/*.swift'
  s.swift_version    = '5.0'
end
