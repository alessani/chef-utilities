service "mongodb" do
  provider Chef::Provider::Service::Upstart
  action [:stop]
end

template "/etc/init/mongodb.conf" do
  source "mongodb.conf.erb"
  mode 0644
  owner "root"
  group "root"
end

service "mongodb" do
  provider Chef::Provider::Service::Upstart
  supports [:start, :restart, :stop, :status]
  #starts the service if it's not running and enables it to start at system boot time
  action [:enable, :start]
end