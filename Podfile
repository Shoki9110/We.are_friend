# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.5'
      end
   end
  end
end
target 'We are friend' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for We are friend

  pod 'FirebaseFirestore'
  pod 'FirebaseAuth'

end
