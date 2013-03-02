execute "postgres stop" do
  command "service postgresql stop"
end

execute "install-postgresql" do
  command "mv /var/lib/postgresql/#{node[:postgresql][:version]}/main #{node['postgresql']['lib_dir']}/main"
  not_if do FileTest.directory?(node['postgresql']['lib_dir'] + "/main") end
end

["/var/lib/postgresql/#{node[:postgresql][:version]}/main", node['postgresql']['lib_dir']].each do |dir|
  directory dir do
    owner "postgres"
    group "postgres"
  end
end

mount "/var/lib/postgresql/#{node[:postgresql][:version]}/main" do
  device "#{node['postgresql']['lib_dir']}/main"
  fstype "none"
  options "bind,rw"
  action :mount
end

execute "postgres start" do
  command "service postgresql start"
end