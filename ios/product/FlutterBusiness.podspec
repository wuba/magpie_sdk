#
# Generated file, do not edit.
#

Pod::Spec.new do |s|
  s.name             = 'FlutterBusiness'
  s.version          = '0.0.1'
  s.summary          = 'App.framework PluginRegistary'
  s.description      = <<-DESC
App.framework
Depends on all your plugins, and provides a function to register them.
                       DESC
  s.homepage         = 'https://flutter.dev'
  s.license          = { :type => 'BSD' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.ios.deployment_target = '8.0'
  s.source_files =  "*.{h,m}"
  s.source           = { :path => '.' }
  s.public_header_files = './Classes/**/*.h'
  s.vendored_frameworks = 'App.framework'
  s.dependency 'Flutter'
end
