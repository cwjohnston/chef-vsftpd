# This option represents a directory which vsftpd will try to change into after
# a local (i.e. non-anonymous) login. Failure is silently ignored.
default[:vsftpd][:local_root] = "/home/$USER"
default[:vsftpd][:virtual_users] = []
