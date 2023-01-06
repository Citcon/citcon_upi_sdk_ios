#
# Be sure to run `pod lib lint CPaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CPaySDK'
  s.version          = '2.0.9'
  s.summary          = 'UPI mobile SDK for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    
  Release UPI mobile SDK for iOS.
  
  The Citcon’s iOS app payment solution provides a convenient, safe, and reliable payment services to third-party applications. By using the SDK, merchant developers can focus on business logics without having to understand the pluming of payment transactions. The payment experience will be totally transparent and seamless to end consumers.
  
  
  DESC

  s.homepage         = 'https://github.com/Citcon/citcon_upi_sdk_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yansheng.ao@citcon.cn' => 'yansheng.ao@citcon.cn' }
  s.source           = { :git => 'https://github.com/Citcon/citcon_upi_sdk_ios.git', :tag => 'v' + s.version.to_s }

#  s.exclude_files = ['PPRiskMagnes.xcframework', 'Alamofire.xcframework', 'Braintree.xcframework', 'CardinalMobile.xcframework']
  
#  s.ios.deployment_target = '13.0'

  s.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => true , 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
   }

  s.libraries = 'stdc++'#,'z','c++'
  s.requires_arc = true


#  s.resources = 'StaticLibrary/Resources/AlipaySDK.{bundle}'

  s.static_framework = false
  
  s.platform         = :ios, "13.0"
  # s.compiler_flags   = "-Wall -Werror -Wextra"
  # s.swift_version    = "5.1"


  s.default_subspecs = %w[Core Ext]

  s.subspec 'Core' do |ss|
    # Alamofire 5.5.0
    ss.vendored_frameworks = 'CPaySDK/Core/*.{framework,xcframework}'
  end

  s.subspec 'Ext' do |ss|
      # btd 9.3.0, bt 5.5.0
      
      ss.subspec 'CardinalMobile' do |sss|
          # btd 9.3.0, bt 5.5.0
          sss.vendored_frameworks = 'CPaySDK/Ext/CardinalMobile.{framework,xcframework}'
      end
      
      ss.subspec 'PPRiskMagnes' do |sss|
          # btd 9.3.0, bt 5.5.0
          sss.vendored_frameworks = 'CPaySDK/Ext/PPRiskMagnes.{framework,xcframework}'
      end
  end


  
end
