gem_package "pg"

postgresql_connection_info = {:host => "127.0.0.1", :port => 5432, :username => 'postgres', :password => node['postgresql']['password']['postgres']}

pgdata = data_bag_item("dbusers", "misshobby")

# if pgdata['database']
#   mysql_database pgdata['database'] do
#     connection postgresql_connection_info
#     action :create
#   end
# end
  
# mysql_database_user pgdata['name'] do
#   connection postgresql_connection_info
#   password pgdata['password']
#   database_name pgdata['database'] if pgdata['database']
#   host 'localhost'
#   action :grant
# end

r = package "ruby-pg" do
  package_name "libpgsql-ruby"
  action :nothing
end
r.run_action(:upgrade)

# Snippet from opscode to reload gems
require 'rubygems'
Gem.clear_paths
require "pg"

execute "create-database-user" do
  command "createuser -U postgres -SDRw #{pgdata['name']}"
  only_if do
    c = PGconn.connect(:user => 'postgres', :dbname => 'postgres')
    r = c.exec("SELECT COUNT(*) FROM pg_user WHERE usename='#{pgdata['name']}'")
    r.entries[0]['count'] == "0"
  end
end

pgdata['database'].each do |db|
  execute "create-database-#{db}" do
    command "createdb -U postgres -O #{pgdata['name']} -E utf8 -T template0 #{db}"
    only_if do
      c = PGconn.connect(:user => 'postgres', :dbname => 'postgres')
      r = c.exec("SELECT COUNT(*) FROM pg_database WHERE datname='#{db}'")
      #Chef::Log.info("----------------\n\nMinchia #{r.entries[0]['count']} per #{db}\n\n--------------")
      r.entries[0]['count'] == "0"
    end
  end
end