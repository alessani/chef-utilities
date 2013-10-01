aws = Chef::EncryptedDataBagItem.load("aws", "main")

aws_ebs_volume "app_ebs_volume" do
  aws_access_key aws['aws_access_key_id']
  aws_secret_access_key aws['aws_secret_access_key']
  size node['apps']['ebs_size']
  device "/dev/sdf"
  action [ :create, :attach ]
  if node['apps']['volume_type'] != 'standard'
    volume_type node['apps']['volume_type']
    piops node['apps']['piops']
  end
end

bash "format-data-ebs" do
  code "mkfs.ext4 -j -F /dev/xvdf"
  not_if "e2label /dev/xvdf"
end

directory "/mnt/apps"

mount '/mnt/apps' do
  action [:mount, :enable]  # mount and add to fstab
  device '/dev/xvdf'
  fstype 'ext4'
  options 'defaults'
end

directory "/mnt/apps" do
  owner "ubuntu"
  group "ubuntu"
end
