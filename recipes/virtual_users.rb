package "libpam-pwdfile"
package "openssl"

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

(node[:vsftpd][:virtual_users] || []).each do |u|
  directory u[:root].gsub('/./','/') do
    owner u[:local_user] || node[:vsftpd][:guest_username]
    group u[:group]
    recursive true
    mode u[:mode]
  end
  vsftpd_user u[:name] do
    action :add
    username u[:name]
    password u[:password]
    root u[:root]
    local_user u[:local_user] if u[:local_user]
  end
end
