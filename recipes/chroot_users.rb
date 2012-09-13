template "/etc/vsftpd/chroot_list.conf" do
  source "chroot_list.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[vsftpd]"
end
