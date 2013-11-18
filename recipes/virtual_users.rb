package "libpam-pwdfile"
package "openssl"

template "/etc/pam.d/vsftpd.virtual" do
  source "vsftpd-pam.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
end
node.set[:vsftpd][:pam_service_name] = "vsftpd.virtual"

include_recipe "vsftpd"

directory node[:vsftpd][:user_config_dir] do
  owner "root"
  group "root"
  mode 0755
end

file node[:vsftpd][:user_passwd_file] do
  owner "root"
  group "root"
  mode 0600
end

node[:vsftpd][:virtual_users].each do |vuser|
  directory vuser[:root].gsub('/./','/') do
    owner vuser[:local_user] || node[:vsftpd][:guest_username]
    group vuser[:group]
    recursive true
    mode vuser[:mode]
  end
  vsftpd_user vuser[:name] do
    action :add
    username vuser[:name]
    password vuser[:password]
    root vuser[:root]
    local_user vuser[:local_user] if vuser[:local_user]
  end
end
