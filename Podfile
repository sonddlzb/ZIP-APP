platform :ios, '12.0'

def is_pod_binary_cache_enabled
  ENV['IS_POD_BINARY_CACHE_ENABLED'] == 'true'
end

if is_pod_binary_cache_enabled
  plugin 'cocoapods-binary-cache'
  config_cocoapods_binary_cache(
    cache_repo: {
      "default" => {
        "local" => "~/.cocoapods-binary-cache/ZIP-APP-lib"
      }
    },
    prebuild_config: "Debug",
    device_build_enabled: true,
    xcframework: true,
    bitcode_enabled: true
  )
end

def binary_pod(name, *args)
  if is_pod_binary_cache_enabled
    pod name, args, :binary => true
  else
    pod name, args
  end
end

def RIBsPod
  pod 'RIBs', :git => 'https://github.com/uber/RIBs/', :tag => 'v0.10.0'
end

target 'ZIP-APP' do
  use_frameworks!

  RIBsPod()
  binary_pod 'TLLogging'
  binary_pod 'SwiftLint'
  binary_pod 'SVProgressHUD'
  binary_pod 'Resolver'
  binary_pod 'RxSwift'
  binary_pod 'RxCocoa'

  binary_pod 'Alamofire'

  binary_pod 'lottie-ios'
  binary_pod 'DifferenceKit'
end