package "libpam-pwdfile"

template "/etc/pam.d/vsftpd" do
  source "vsftpd-pam.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end

directory node[:vsftpd][:user_config_dir] do
  owner "root"
  group "root"
  mode 0755
end
