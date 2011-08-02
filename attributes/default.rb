#
# Cookbook Name:: vsftpd
# Attribute File:: sudoers
#
# Copyright 2010 Robert J. Berger
#
# Author: Robert J. Berger
# Author: Cameron W. Johnston
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Runtime options
default[:vsftpd][:use_localtime] = false
default[:vsftpd][:dirmessage_enable] = true
default[:vsftpd][:nopriv_user] = "nobody"
default[:vsftpd][:pam_service_name] = "vsftpd"
default[:vsftpd][:listen_ipv6_exclusively] = false
default[:vsftpd][:setproctitle_enable] = false
default[:vsftpd][:pasv] = true
default[:vsftpd][:pasv_port_range] = "1024,1048"
# Login options
default[:vsftpd][:anonymous_enable] = false
default[:vsftpd][:local_enable] = false
default[:vsftpd][:write_enable] = false
# Anonymous user options
default[:vsftpd][:anon_upload_enable] = false
default[:vsftpd][:anon_mkdir_write_enable] = false
default[:vsftpd][:chown_uploads] = false
default[:vsftpd][:chown_username] = "ftp"
# umask options

default[:vsftpd][:chroot_local_user] = true
default[:vsftpd][:chroot_list_enabled] = true
default[:vsftpd][:chroot_users] = Array.new
default[:vsftpd][:chroot_list_file] = "/etc/vsftpd.chroot_list"
# SSL options
default[:vsftpd][:ssl_enable] = true
default[:vsftpd][:use_ssl_certs_from_cookbook] = true
default[:vsftpd][:require_ssl_reuse] = false
default[:vsftpd][:ssl_cert_path] = "/etc/ssl/certs"
default[:vsftpd][:ssl_private_key_path] = "/etc/ssl/private"
default[:vsftpd][:ssl_certs_basename] = "ftp.example.com"
# Logging options
default[:vsftpd][:xferlog_enable] = true
default[:vsftpd][:xferlog_file] = "/var/log/vsftpd.log"
default[:vsftpd][:xferlog_std_format] = false
# Session and security options
default[:vsftpd][:connect_from_port_20] = true
default[:vsftpd][:async_abor_enable] = true
default[:vsftpd][:idle_session_timeout] = 600
default[:vsftpd][:data_connection_timeout] = 120
default[:vsftpd][:deny_file] = Array.new
default[:vsftpd][:max_per_ip] = 0
# Virtual user options
default[:vsftpd][:virtual_users_enable] = false
default[:vsftpd][:guest_username] = "ftp"
default[:vsftpd][:guest_enable] = true
default[:vsftpd][:user_config_dir] = "/etc/vsftpd.userconf"
default[:vsftpd][:virtual_use_local_privs] = false
