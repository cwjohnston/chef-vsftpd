package "vsftpd"

service "vsftpd" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

template "/etc/vsftpd.conf" do
  source "vsftpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "vsftpd")
end

chroot_users
