include_recipe "vsftpd"
include_recipe "vsftpd::ssl"
include_recipe "vsftpd::chroot_users"
include_recipe "vsftpd::virtual_users"
