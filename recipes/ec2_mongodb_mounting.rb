aws = Chef::EncryptedDataBagItem.load("aws", "main")

aws_ebs_volume "mongodb_ebs_volume" do
  aws_access_key aws['aws_access_key_id']
  aws_secret_access_key aws['aws_secret_access_key']
  size node['mongodb']['ebs_size']
  device "/dev/sdi"
  action [ :create, :attach ]
  if node['mongodb']['volume_type'] != 'standard'
    volume_type node['mongodb']['volume_type']
    piops node['mongodb']['piops']
  end
end

bash "format-data-ebs" do
  code "mkfs.ext4 -j -F /dev/xvdi"
  not_if "e2label /dev/xvdi"
end

directory "/mnt/mongodb"

mount '/mnt/mongodb' do
  action [:mount, :enable]  # mount and add to fstab
  device '/dev/xvdi'
  fstype 'ext4'
  options 'defaults'
end

directory "/mnt/mongodb" do
  owner "ubuntu"
  group "ubuntu"
end
