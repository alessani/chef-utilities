rbenv_gem "passenger" do
  ruby_version "#{node[:rubymachine][:patched_rubies].first}-perf"
  gem_binary "/opt/rbenv/versions/#{node[:rubymachine][:patched_rubies].first}-perf/bin/gem"
  version "--pre"
end

execute "install passenger for apache2" do
  command "passenger-install-apache2-module"
end