package "vsftpd"

service "vsftpd" do
  supports :status => true, :stop => true, :start => true, :restart => true
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

directory node[:vsftpd][:user_config_dir] do
  owner "root"
  group "root"
  mode 0755
end

file node[:vsftpd][:user_passwd_file] do
  owner "root"
  group "root"
  mode 0600
  action :create_if_missing
end

if node['vsftpd']['chroot_local_user'] or node['vsftpd']['chroot_list_enable']
  include_recipe "vsftpd::chroot_users"
end

if node['vsftpd']['virtual_users_enable']
  include_recipe "vsftpd::virtual_users"
end
