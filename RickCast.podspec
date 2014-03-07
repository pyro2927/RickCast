#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "RickCast"
  s.version          = "0.1.0"
  s.summary          = "Rickroll everyone"
  s.description      = "RickCast connects to any found Chromecasts and plays Rick Astley's 'Never Gonna Give You Up'"
  s.homepage         = "https://github.com/pyro2927/RickCast"
  s.license          = 'MIT'
  s.author           = { "pyro2927" => "joseph@pintozzi.com" }
  s.source           = { :git => "https://github.com/pyro2927/RickCast", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pyro2927'

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.public_header_files = 'Classes/*.h'
  s.frameworks = 'GoogleCast'
  s.dependency 'google-cast-sdk', '~> 2.0'
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/google-cast-sdk/GoogleCastFramework-2.0-Release', 'OTHER_LDFLAGS' => '-framework GoogleCast' }
end
