aws = Chef::EncryptedDataBagItem.load("aws", "main")

aws_ebs_volume "redis_ebs_volume" do
  aws_access_key aws['aws_access_key_id']
  aws_secret_access_key aws['aws_secret_access_key']
  size node['redis']['ebs_size']
  device "/dev/sdh"
  action [ :create, :attach ]
  if node['redis']['volume_type'] != 'standard'
    volume_type node['redis']['volume_type']
    piops node['redis']['piops']
  end
end

bash "format-data-ebs" do
  code "mkfs.ext4 -j -F /dev/xvdh"
  not_if "e2label /dev/xvdh"
end

directory "/mnt/redis"

mount '/mnt/redis' do
  action [:mount, :enable]  # mount and add to fstab
  device '/dev/xvdh'
  fstype 'ext4'
  options 'defaults'
end

directory "/mnt/redis" do
  owner "ubuntu"
  group "ubuntu"
end
