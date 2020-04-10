  Pod::Spec.new do |s|
    s.name             = 'MagpieBridge'
    s.version          = '1.0.0'
    s.platform         = :ios, '8.0'
    s.summary          = 'MagpieBridge'
    s.description      = <<-DESC
                          MagpieBridge
                          DESC
    s.homepage         = 'https://flutter.io'
    s.license          = { :type => 'MIT' }
    s.author           = { 'sac' => 'zdl51go@gmail.com' }
    s.source           = { :git => 'https:', :tag => s.version.to_s }

    s.source_files = '*/*.{h,m,mm}'
    s.libraries = 'c++'
    s.xcconfig = {
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
      'CLANG_CXX_LIBRARY' => 'libc++',
      'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/**'
    }

    s.ios.vendored_libraries =  'libMagpieBridge.a'
    s.dependency 'Flutter'

  end
