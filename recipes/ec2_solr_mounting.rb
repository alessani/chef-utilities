aws = Chef::EncryptedDataBagItem.load("aws", "main")

aws_ebs_volume "solr_ebs_volume" do
  aws_access_key aws['aws_access_key_id']
  aws_secret_access_key aws['aws_secret_access_key']
  size node['solr']['ebs_size']
  device "/dev/sdj"
  action [ :create, :attach ]
  if node['solr']['volume_type'] != 'standard'
    volume_type node['solr']['volume_type']
    piops node['solr']['piops']
  end
end

bash "format-data-ebs" do
  code "mkfs.ext4 -j -F /dev/xvdj"
  not_if "e2label /dev/xvdj"
end

directory "/mnt/solr"

mount '/mnt/solr' do
  action [:mount, :enable]  # mount and add to fstab
  device '/dev/xvdj'
  fstype 'ext4'
  options 'defaults'
end

directory "/mnt/solr" do
  owner "jetty"
  group "adm"
end