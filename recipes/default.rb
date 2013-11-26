package "vsftpd"

template "/etc/vsftpd.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[vsftpd]"
end

directory "/etc/vsftpd" do
  owner "root"
  group "root"
  mode 0755
end

directory node[:vsftpd][:user_config_dir] do
  owner "root"
  group "root"
  mode 0755
end

include_recipe "vsftpd::chroot_users" if node['vsftpd']['chroot_local_user'] || node['vsftpd']['chroot_list_enable']
include_recipe "vsftpd::virtual_users" if node['vsftpd']['virtual_users_enable']

service "vsftpd" do
  supports :status => true, :stop => true, :start => true, :restart => true
  action [:enable, :start]
end
