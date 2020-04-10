Pod::Spec.new do |s|
  s.name             = 'Flutter'
  s.version          = '1.12.13'
  s.platform         = :ios, '8.0'
  s.summary          = 'Flutter'
  s.description      = <<-DESC
  FlutterFramework
                        DESC
  s.homepage         = 'https://flutter.io'
  s.license          = { :type => 'BSD' }
  s.author           = { 'sac' => 'zdl51go@gmail.com' }
  s.source           = { :git => 'https:', :tag => s.version.to_s }

  s.source_files = '**/*.{h,m,mm}'
  s.xcconfig = {
    'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/**'
  }

  fdebug = 'debug/Flutter.framework'
  frelease = 'release/Flutter.framework'
  s.exclude_files =           ENV['debug'] == '1' ?  frelease : fdebug
  s.ios.vendored_frameworks = ENV['debug'] == '1' ?  fdebug : frelease

end
