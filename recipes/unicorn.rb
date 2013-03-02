node['apps']['running'].each do |app|
  template "/etc/logrotate.d/#{app}" do
    source "app_logrotate.erb"
    owner "root"
    mode 0440
    action :create_if_missing
    variables(
      :app => app
    )
  end

  directory "/var/run/#{app}" do
    user "ubuntu"
    group "ubuntu"
  end
end
