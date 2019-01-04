# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Todotrix' do
pod 'R.swift'
pod 'LTSwiftDate'
pod 'TextAttributes'
pod 'RealmSwift', '3.13.1'
pod 'HPReorderTableView'
pod 'VBFPopFlatButton'
pod 'Fabric'
pod 'Crashlytics'
pod 'Heap'
end

target 'TodotrixTodayExtension' do
    pod 'RealmSwift', '3.13.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end

