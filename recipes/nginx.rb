template "/etc/init/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

bash "remove nginx from init.d and rc level" do
  code <<-EOH
    /etc/init.d/nginx stop
    update-rc.d -f nginx remove
  EOH
end


service "nginx" do
  provider Chef::Provider::Service::Upstart
	supports [:start, :restart, :stop, :status]
  #starts the service if it's not running and enables it to start at system boot time
	action [:enable, :start]
end
