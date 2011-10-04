if found_users = search(:ftp_users)
  directory "/etc/vsftpd.userconf"

  found_users.each do |user|
    # virt_users << user['id']

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
