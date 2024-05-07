source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'TinyHub' do

  pod 'HiIOS', '1.2.7'

  # Base
  pod 'RxGesture', '4.0.4'
  pod 'IQKeyboardManagerSwift', '6.5.11'
  pod 'ReusableKit-Hi/RxSwift', '3.0.0-v4'
  pod 'DefaultsKit', '0.2.0'
  pod 'R.swift', '6.1.0'
  pod 'SwiftLint', '0.50.3'
  pod 'Umbrella/Core', '0.12.0'
  pod 'SnapKit', '5.6.0'
  
  # Advanced
  pod 'MXParallaxHeader', '1.1.0'
  pod 'Parchment', '3.3.0'
  pod 'TagListView', '1.4.1'
  pod 'SwiftSVG', '2.3.2'
  pod 'Toast-Swift-Hi', '5.0.1-v3'
  pod 'SwiftEntryKit', '2.0.0'
  pod 'TTTAttributedLabel', '2.0.0'
  pod 'DateToolsSwift-Hi', '5.0.0-v6'
  pod 'Highlightr', '2.1.0'
  pod 'AMPopTip', '4.12.0'
  
  # Platform
  pod 'AlicloudMANLight', '1.1.0'   			# 数据分析
  pod 'AlicloudCrash', '1.2.0-no-memory'      	# 崩溃分享
  pod 'AlicloudAPM', '1.1.1'        			# 性能分析
  pod 'AlicloudTLog', '1.0.1.2'     			# 远程日志
  pod 'AlicloudUT', '5.2.0.16'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
	  if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
	    xcconfig_path = config.base_configuration_reference.real_path
	    IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
	  end
    end
  end
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
        "layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
end

def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      FileUtils.chmod("+w", name)
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
