package "libcurl4-openssl-dev"
package "apache2-threaded-dev"
package "libapr1-dev"

ruby_ver = node[:rbenv][:rubies].first
passenger_version = node[:passenger][:version]
rbenv_path = "/usr/local/rbenv/versions"

rbenv_gem "passenger" do
  rbenv_version ruby_ver
  #gem_binary "/opt/rbenv/versions/#{ruby_ver}/bin/gem"
  version passenger_version
end

execute "install passenger #{passenger_version} for apache2" do
  command "#{rbenv_path}/#{ruby_ver}/bin/passenger-install-apache2-module --auto"
  not_if {::File.exists?("#{path}/#{ruby_ver}/lib/ruby/gems/1.9.1/gems/passenger-#{passenger_version}/libout/apache2/mod_passenger.so")}
end

template "/etc/apache2/mods-available/passenger.load" do
  source "passenger.load.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :ruby_version => ruby_ver,
    :passenger_version => passenger_version,
    :rbenv_path => rbenv_path
  )
end

link "/etc/apache2/mods-enabled/passenger.load" do
  to "/etc/apache2/mods-available/passenger.load"
end

service "apache2" do
  action :restart
end