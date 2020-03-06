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
  s.summary          = 'a qiibee Wallet SDK'

  s.description      = <<-DESC
'With qbWallet SDK you can create new wallet or restore existing one. Get wallet balances, tokens and perform transactions.'
                       DESC

  s.homepage         = 'https://github.com/qiibee/qb-wallet-sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qbxelvis' => 'elvis@qiibee.ch' }
  s.source           = { :git => 'https://github.com/qiibee/qb-wallet-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.source_files = 'qbWalletSDK/Classes/**/*'

  s.static_framework = true
  s.swift_version = '5.0'
  
  s.platforms = {
    "ios" => "12.0"
  }


  s.dependency 'SwiftKeychainWrapper'
  s.dependency 'Alamofire', '~> 5.0.0-rc.3'
  s.dependency 'HDWalletKit', '0.3.6'
  s.dependency 'SwiftyJSON', '~> 4.0'
end
