include_recipe "apt"
include_recipe "git"
include_recipe "ntp"
include_recipe "openssl"
include_recipe "build-essential"

package "unzip"
package "htop"

#directory "/home/#{node[:user][:name]}/example" do
#  owner node[:user][:name]
#end
#
#file "/home/#{node[:user][:name]}/example/index.html" do
#  owner node[:user][:name]
#  content "<h1>Hello World!</h1>"
#end
#
#file "#{node[:nginx][:dir]}/sites-available/example" do
#  content "upstream unicorn {
#    server unix:/tmp/unicorn.mfc.sock fail_timeout=0; 
#  }
#  
#  server {
#   listen 80 default;
#   server_name test.extendi.it;
#   root /home/#{node[:user][:name]}/apps/mfc/current/public;
#   try_files $uri/index.html $uri @unicorn;
#    location @unicorn {
#      proxy_pass http://unicorn;
#    }
#  }"
#end

#nginx_site "example"

#service "nginx" do
#  action :restart
#end
#
