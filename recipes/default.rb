package "vsftpd"

service "vsftpd" do
  supports :status => true, :restart => true
  action :enable
end

template "/etc/vsftpd.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "vsftpd"), :delayed
end

directory "/etc/vsftpd" do
  owner "root"
  group "root"
  mode 0755
end
