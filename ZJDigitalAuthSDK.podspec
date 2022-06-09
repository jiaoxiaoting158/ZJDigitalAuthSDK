

Pod::Spec.new do |s|


  s.name         = "ZJDigitalAuthSDK"
  s.version      = "4.0.0"
  s.summary      = "中交兴路车辆授权SDK."
  s.description  = <<-DESC
  此SDK为中交兴路此查看车辆位置的授权SDK
                   DESC
  s.homepage     = "https://gitee.com/yanglinda/zjdigital-auth-sdk.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "jiaoxiaoting" => "jiaoxiaoting@sinoiov.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://gitee.com/yanglinda/zjdigital-auth-sdk.git", :tag => "#{s.version}" }
  
  s.vendored_frameworks = 'Framework/ZJDigitalAuthSDK.framework'
  s.resources = 'ZFramework/ZJDigitalAuthSDK.framework/*.bundle'
  
  s.static_framework = true
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'armv7 arm64' }

  s.dependency "AFNetworking","~> 4.0.0"
  s.dependency "SDWebImage"
  s.dependency "MBProgressHUD"
  s.dependency "Toast"
  s.dependency "YYKit"
  
  s.frameworks   = 'UIKit','Foundation','AVFoundation'
end
