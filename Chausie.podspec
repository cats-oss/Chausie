Pod::Spec.new do |s|
  s.name             = 'Chausie'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Chausie.'
  s.homepage         = 'https://github.com/shoheiyokoyama/Chausie'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shoheiyokoyama' => 'shohei.yok0602@gmail.com' }
  s.source           = { :git => 'https://github.com/shoheiyokoyama/Chausie.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'Chausie/**/*.swift'
  s.swift_version    = '5.0'
end
