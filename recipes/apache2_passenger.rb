rbenv_gem "passenger" do
  ruby_version "#{node[:rubymachine][:default]}"
  gem_binary "/opt/rbenv/versions/#{node[:rubymachine][:default]}/bin/gem"
  version "4.0.0.rc4"
end

execute "install passenger 4.0.rc4 for apache2" do
  command "/opt/rbenv/versions/#{node[:rubymachine][:default]}/bin/passenger-install-apache2-module"
end