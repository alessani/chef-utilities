gem_package "mysql" # recipe mysql use mysql, not mysql2 gem

secrets = Chef::EncryptedDataBagItem.load("dbusers", "root")
Chef::Log.info("The mysql password is: '"+ secrets['password_root'] + "'")
mysql_connection_info = {:host => node['mysql']['hostname'], :username => 'root', :password => secrets['password_root']}

node['dbusers'].each do |username|
  user = Chef::EncryptedDataBagItem.load('dbusers', username)
  
  if user['database']
    mysql_database user['database'] do
      connection mysql_connection_info
      action :create
    end
  end
  
  mysql_database_user user['name'] do
    connection mysql_connection_info
    password user['password']
    database_name user['database'] if user['database']
    host 'localhost'
    privileges user['privileges']
    action :grant
  end
end
