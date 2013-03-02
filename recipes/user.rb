# file "/home/#{node[:user][:name]}/.gemrc" do
#   owner node[:user][:name]
#   content "gem: --no-ri --no-rdoc"
#   action :create_if_missing
# end

user node[:user][:name] do
  password node[:user][:password]
  gid "admin"
  home "/home/#{node[:user][:name]}"
  supports :manage_home => true
  shell "/bin/bash"
end

file "/home/#{node[:user][:name]}/.gemrc" do
  owner node[:user][:name]
  content "gem: --no-ri --no-rdoc"
  action :create_if_missing
end

# Create the .ssh if it doesn't exist
directory "/home/#{node[:user][:name]}/.ssh" do
  owner "deployer"
  mode "0755"
  action :create
  not_if { File.directory?("/home/#{node[:user][:name]}/.ssh") }
end

if node[:user][:ssh_keys].any?
  template "/home/#{node[:user][:name]}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner node[:user][:name]
    mode 0440
    action :create_if_missing
    variables(
      :ssh_keys => node[:user][:ssh_keys],
      :user => node[:user][:name]
    )
  end
  
  template "/etc/sudoers.d/90-deployer-ubuntu" do
    source "90-deployer-ubuntu.erb"
    mode 0440
    owner "root"
    group "root"
    variables(
      :sudoers_groups => node[:authorization][:sudo][:groups],
      :sudoers_users => node[:authorization][:sudo][:users],
      :passwordless => true
    )
  end
end
