
require 'find'
# Install pods needed to embed Flutter application.
# from the host application Podfile.
#
# @example
#   target 'MyApp' do
#     install_flutter_business_pods
#   end
def install_flutter_business_pods
  install_business_pods
  install_plugin_pods
end

# Install App.framework & Plugin Registry
#
# @example
#   target 'MyApp' do
#     install_business_pods
#   end
def install_business_pods
  current_dir = Pathname.new __dir__
  project_dir= Pathname.new Dir.pwd
  relative = current_dir.relative_path_from project_dir
  pod 'FlutterBusiness', :path => relative
end

# Install Flutter plugin pods.
#
# @example
#   target 'MyApp' do
#     install_plugin_pods
#   end
def install_plugin_pods
  current_dir = Pathname.new __dir__
  project_dir= Pathname.new Dir.pwd
  relative = current_dir.relative_path_from project_dir
  pluginDir = File.join(relative.to_s, 'Plugins')
  if File.directory?(pluginDir) then
      plugins = Dir.children(pluginDir).each{}
      plugins.map do |r|
      if r != '.DS_Store' then
        podDir = File.join(pluginDir, r)
        pod r, :path => podDir, :nhibit_warnings => true
        puts(r)
      end
    end
  end
end

