rbenv_gem "passenger" do
  ruby_version "#{node[:rubymachine][:patched_rubies].first}-perf"
  gem_binary "/opt/rbenv/versions/#{node[:rubymachine][:patched_rubies].first}-perf/bin/gem"
  version "4.0.0.rc4"
end

rbenv_script "install passenger for apache2" do
  rbenv_version "#{node[:rubymachine][:patched_rubies].first}-perf"
  code "passenger-install-apache2-module"
end