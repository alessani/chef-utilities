
directory node[:solr][:data_directory] do
  owner "jetty"
  group "adm"
end

file "#{node[:solr][:data_directory]}/solr.xml" do
  content('<solr persistent="true">
   <cores adminPath="/admin/cores">' + node[:solr][:apps].map{|app| "<core name=\"#{app}\" instanceDir=\"#{app}\" dataDir=\"#{node[:solr][:data_directory]}/#{app}/data\" />"   }.join("") + '</cores>
  </solr>')
end

node[:solr][:apps].each do |dir|
  ["data", "data/index", "data/spellchecker"].each do |inside|
    directory "/mnt/apps/#{dir}/current/solr/#{inside}" do
      owner "jetty"
      group "adm"
    end
  end

  link "#{node[:solr][:data_directory]}/#{dir}" do
    to "/mnt/apps/#{dir}/current/solr"
  end

end
