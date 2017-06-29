#
# Be sure to run `pod lib lint Harold.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Harold'
  s.version          = '0.2.2'
  s.summary          = 'Simple discoverabiliy layer for Swift and Node.js'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simple discoverabiliy layer for Swift and Node.js – Find your apps and devices on your local subnet
by broadcasting (or scanning for) UDP-layer messages
                       DESC

  s.homepage         = 'https://github.com/lacyrhoades/harold'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lacy Rhoades' => 'lacyrhoades@gmail.com' }
  s.source           = { :git => 'https://github.com/lacyrhoades/harold.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lacyrhoades'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Swift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Harold' => ['Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CocoaAsyncSocket'
end
