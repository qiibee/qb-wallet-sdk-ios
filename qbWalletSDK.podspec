#
# Be sure to run `pod lib lint qbWalletSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'qbWalletSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of qbWalletSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/qbxelvis/qbWalletSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qbxelvis' => 'elvis@qiibee.ch' }
  s.source           = { :git => 'https://github.com/qbxelvis/qbWalletSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'qbWalletSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'qbWalletSDK' => ['qbWalletSDK/Assets/*.png']
  # }
  
  s.static_framework = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'SwiftKeychainWrapper'
    s.dependency 'Alamofire', '~> 5.0.0-rc.3'
    s.dependency 'HDWalletKit'
    s.dependency 'SwiftyJSON', '~> 4.0'
end
