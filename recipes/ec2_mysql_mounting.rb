aws = Chef::EncryptedDataBagItem.load("aws", "main")

aws_ebs_volume "db_ebs_volume" do
  aws_access_key aws['aws_access_key_id']
  aws_secret_access_key aws['aws_secret_access_key']
  size node['mysql']['ebs_size']
  device "/dev/sdg"
  action [ :create, :attach ]
  if node['mysql']['volume_type'] != 'standard'
    volume_type node['mysql']['volume_type']
    piops node['mysql']['piops']
  end
end

bash "format-db-ebs" do
  code "mkfs.ext4 -j -F /dev/xvdg"
  not_if "e2label /dev/xvdg"
end

directory "/mnt/mysql" do
  owner "mysql"
  group "mysql"
end

mount '/mnt/mysql' do
  action [:mount, :enable]  # mount and add to fstab
  device '/dev/xvdg'
  fstype 'ext4'
  options 'defaults'
end
