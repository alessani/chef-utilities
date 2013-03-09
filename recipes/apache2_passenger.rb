rbenv_gem "passenger" do
  ruby_version "#{node[:rubymachine][:patched_rubies].first}-perf"
  gem_binary "/opt/rbenv/versions/#{node[:rubymachine][:patched_rubies].first}-perf/bin/gem"
  version "4.0.0.rc4"
end

execute "install passenger for apache2" do
  command "rbenv shell #{node[:rubymachine][:patched_rubies].first}-perf; passenger-install-apache2-module"
end