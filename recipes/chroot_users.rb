file "/etc/vsftpd/chroot_list.conf" do
  owner "root"
  group "root"
  mode 0644
  action :create_if_missing
end
