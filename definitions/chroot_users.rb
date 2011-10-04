define :chroot_users, :users => nil do
  users = params[:users] || node[:vsftpd][:chroot_users]

  template "/etc/vsftpd.chroot_list" do
    source "vsftpd.chroot_list"
    cookbook "vsftpd"
    owner "root"
    group "root"
    mode 0644
    variables(:users => users)
  end
end
