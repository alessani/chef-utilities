package "libcurl4-openssl-dev"
package "apache2-threaded-dev"
package "libapr1-dev"

ruby_ver = node[:rbenv][:rubies].first
passenger_version = node[:passenger][:version]
rbenv_path = "/usr/local/rbenv/versions"

ruby_main_ver = case ruby_ver[0..2]
  when "1.9"
    "1.9.1"
  when "1.8"
    "1.8"
  end

rbenv_gem "passenger" do
  rbenv_version ruby_ver
  #gem_binary "/opt/rbenv/versions/#{ruby_ver}/bin/gem"
  version passenger_version
end

execute "install passenger #{passenger_version} for apache2" do
  command "#{rbenv_path}/#{ruby_ver}/bin/passenger-install-apache2-module --auto"
  not_if {::File.exists?("#{rbenv_path}/#{ruby_ver}/lib/ruby/gems/#{ruby_main_ver}/gems/passenger-#{passenger_version}/buildout/apache2/mod_passenger.so")}
end

template "/etc/apache2/mods-available/passenger.load" do
  source "passenger.load.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :ruby_version => ruby_ver,
    :passenger_version => passenger_version,
    :rbenv_path => rbenv_path,
    :ruby_main_ver => ruby_main_ver,
    :number_of_passenger => node[:passenger][:number_of_passenger]
  )
end

link "/etc/apache2/mods-enabled/passenger.load" do
  to "/etc/apache2/mods-available/passenger.load"
end

service "apache2" do
  action :restart
end