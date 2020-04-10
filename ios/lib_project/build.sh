#!/bin/sh
export LANG="zh_CN.UTF-8"
# 如果当前.sh不支持./xx.sh运行，先修改权限chmod a+x xx.sh

#参数1  Version
version=$1
simulatorDir=Release-iphonesimulator
iphoneDir=Release-iphoneos
projectWorkspace=Magpie.xcworkspace
schemeName=Magpie
projct=MagpieBridge
workspace=$PWD
productPath=$workspace/build/product

#在真机上编译，生成.a库
function buildDeviceLibs() {
  cd $workspace
#   建build目录
  mkdir -p $workspace/build
#  # 清理上一次的旧文件
  deleteOldFiles "iphoneos"
  buildARCHS="armv7 arm64"

#  #真机编译
    echo "真机编译开始 `date`"
    xcodebuild -quiet ARCHS="${buildARCHS}" GCC_WARN_INHIBIT_ALL_WARNINGS=YES ONLY_ACTIVE_ARCH=NO \
             -scheme ${schemeName} -workspace ${projectWorkspace} -configuration Release \
                  CONFIGURATION_BUILD_DIR=$workspace/build/$iphoneDir
  ret=$?
  # 如果编译失败，则退出
  if [ $ret -ne 0 ]; then
    echo "真机编译失败啦: ret="$ret
    exit 100000
  fi
  echo "真机编译结束 `date`"
}


#在模拟器上编译，生成.a库
function buildSimulatorLibs() {
  cd $workspace
  # 建build目录
  mkdir -p $workspace/build
  # 清理上一次的旧文件
  deleteOldFiles "iphonesimulator"
  buildARCHS="x86_64"
    #模拟器编译
  echo "模拟器编译开始 `date`"
  buildARCHS="x86_64"
    xcodebuild -quiet ARCHS="${buildARCHS}" -destination "platform=iOS Simulator,name=iPhone 8 Plus" \
        ONLY_ACTIVE_ARCH=NO GCC_WARN_INHIBIT_ALL_WARNINGS=YES -scheme ${schemeName} -workspace ${projectWorkspace} \
           -configuration Release -UseModernBuildSystem=NO CONFIGURATION_BUILD_DIR=$workspace/build/$simulatorDir
  ret=$?
  # 如果编译失败，则退出
  if [ $ret -ne 0 ]; then
    echo "模拟器编译失败啦: ret="$ret
      exit 100000
  fi
  echo "模拟器编译结束 `date`"
}

# 清理之前打包生成的文件，为编译作准备
function deleteOldFiles() {
  local fileType=$1
  local buildDir=$workspace/build
  echo $buildDir
  rm -rf $buildDir/$schemeName.build/Release-$fileType/*
  rm -rf $buildDir/Pods.build/Release-$fileType/*
  rm -rf $buildDir/Release-$fileType/*
}

#合并.a，并将合并后的.a放到merge_dir目录下
function mergeLibs() {
  cd $workspace/build
  mkdir -p $productPath
  echo "开始合并.a文件"
  lipo -create $simulatorDir/lib${projct}.a $iphoneDir/lib${projct}.a -output $productPath/lib${projct}.a
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "合并.a失败啦！ lipo create: ret="$ret
      exit 100000
  fi
  echo "结束合并.a文件"
}


#复制头文件
function copyHeaders() {
 cd $workspace
 headerDir=$productPath/Headers
 mkdir -p $headerDir
 cp $(find ./build/$iphoneDir -type f -name "*.h") $headerDir
}


#复制资源文件
function copyResources() {
 echo '复制资源'
}

#复制资源文件
function writePodspec() {
  cd $productPath
  cat>MagpieBridge.podspec<<EOF
  Pod::Spec.new do |s|
    s.name             = 'MagpieBridge'
    s.version          = '$version'
    s.platform         = :ios, '8.0'
    s.summary          = 'MagpieBridge'
    s.description      = <<-DESC
                          MagpieBridge
                          DESC
    s.homepage         = 'https://flutter.io'
    s.license          = { :type => 'BSD' }
    s.author           = { 'sac' => 'zdl51go@gmail.com' }
    s.source           = { :git => 'https:', :tag => s.version.to_s }

    s.source_files = '*/*.{h,m,mm}'
    s.libraries = 'c++'
    s.xcconfig = {
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
      'CLANG_CXX_LIBRARY' => 'libc++',
      'HEADER_SEARCH_PATHS' => '\${PODS_ROOT}/**'
    }

    s.ios.vendored_libraries =  'libMagpieBridge.a'
    s.dependency 'Flutter'

  end
EOF
}

# 参数校验
if [ ! -n "$version" ]; then
    echo '缺少版本号参数！'
    exit 100000
fi

# 真机下编译
buildDeviceLibs
# 模拟器下编译
buildSimulatorLibs
# 合并.a
mergeLibs
# 提取头文件
copyHeaders
# 提取资源文件
copyResources
# 写入Podspec
writePodspec
