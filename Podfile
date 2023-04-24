# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'forthgreen' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for forthgreen
  pod 'SainiUtils'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Alamofire','4.9.1'
  pod 'IQKeyboardManagerSwift'
  pod 'NVActivityIndicatorView'
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit', '~> 8.0.0'
  pod 'SDWebImage', '~> 4.0'
  pod "SkeletonView"
  pod 'ImageSlideshow', '~> 1.6'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  #pod 'Branch', '~> 0.36.0'
  pod 'Branch'
  pod 'MarkdownView'
  pod 'SideMenu'
  pod "BSImagePicker", "~> 3.1"
  
  pod 'SZMentionsSwift'
  pod 'DropDown'
  
  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
                 end
            end
     end
  end
end
