logrotate_app "jetty" do
  cookbook "logrotate"
  path "/var/log/jetty/*.log"
  frequency "daily"
  options ["missingok", "compress", "copytruncate"]
  rotate 3
end
