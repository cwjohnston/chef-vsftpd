#
# Cookbook Name:: vsftpd
# Recipe:: default
#
# Copyright 2010, Robert J. Berger
#
# Apache License, Version 2.0
#

package "vsftpd"

service "vsftpd" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

directory "/etc/vsftpd.userconf"

if node[:vsftpd][:use_ssl]
  if node[:vsftpd][:use_ssl_certs_from_cookbook]
    cookbook_file "#{node[:vsftpd][:ssl_cert_path]}/#{node[:vsftpd][:ssl_certs_basename]}.pem" do
      owner 'root'
      group 'root'
      mode 0600
    end

    cookbook_file "#{node[:vsftpd][:ssl_private_key_path]}/#{node[:vsftpd][:ssl_certs_basename]}.key" do
      owner 'root'
      group 'root'
      mode 0600
    end
  end
end

virt_users = Array.new

if node[:vsftpd][:virtual_users_enable]

  found_users = search(:ftp_users)
  found_users.each do |user|
    virt_users << user['id']

    if user['conf']
      template "/etc/vsftpd.userconf/#{user['id']}" do
        source "userconf.erb"
        variables(:conf => user['conf'])
      end
    end
  end

  package "libpam-pwdfile"

  cookbook_file "/etc/pam.d/vsftpd" do
    source "vsftpd-pam"
    owner "root"
    group "root"
    mode 0644
  end

  template "/etc/vsftpd.passwd" do
    source "ftpd.passwd.erb"
    owner "root"
    group "root"
    mode 0600
    variables(:users => found_users)
  end

end

template "/etc/vsftpd.conf" do
  source "vsftpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :ssl_cert_path => node[:vsftpd][:ssl_cert_path],
    :ssl_private_key_path => node[:vsftpd][:ssl_private_key_path],
    :ssl_certs_basename => node[:vsftpd][:ssl_certs_basename],
    :chroot_local_user => node[:vsftpd][:chroot_local_user]
  )
  notifies :restart, resources(:service => "vsftpd")
end

chroot_users = node[:vsftpd][:chroot_users]
virt_users.each do |user|
  chroot_users << user
end

template "/etc/vsftpd.chroot_list" do
  source "vsftpd.chroot_list"
  owner "root"
  group "root"
  mode 0644
  variables(:users => chroot_users)
end
