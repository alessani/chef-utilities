# mycookbook/recipes/apt_postgresql_ppa.rb
#
# This recipe should add the sources for
# PostgreSQL 9.1 using the PPA available at:
# https://launchpad.net/~pitti/+archive/postgresql

include_recipe "apt"
  
apt_repository "postgresql" do
  uri "http://ppa.launchpad.net/pitti/postgresql/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "8683D8A2"
  action :add
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end