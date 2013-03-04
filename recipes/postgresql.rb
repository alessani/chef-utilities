# gem_package "pg"
# r = package "ruby-pg" do
#   package_name "libpgsql-ruby"
#   action :nothing
# end
# r.run_action(:upgrade)

include_recipe "postgresql::ruby"

postgresql_connection_info = {:host => "127.0.0.1", :port => 5432, :username => 'postgres', :password => Chef::EncryptedDataBagItem.load("dbusers", "postgres")['password_root']}

pgusers = data_bag("postgresql")


# do the same but pass the provider to the database resource
pgusers.each do |user|
  user = Chef::EncryptedDataBagItem.load('postgresql', user)
  
  postgresql_database user['database'] do
    connection postgresql_connection_info
    action :create
  end

  postgresql_database_user user['id'] do
    connection postgresql_connection_info
    password user['password']
    action :create
  end

  # grant all privileges on all tables in foo db
  postgresql_database_user user['id'] do
    connection postgresql_connection_info
    database_name user['database']
    privileges [:all]
    action :grant
  end


end