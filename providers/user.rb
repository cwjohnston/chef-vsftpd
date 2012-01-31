action :add do
  bash "Adding #{new_resource.username} to vsftp" do
    code %{
      htpasswd -b #{node[:vsftpd][:user_passwd_file]} #{new_resource.username} #{new_resource.password}
    }
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end

  file "#{node[:vsftpd][:user_config_dir]}/#{new_resource.username}" do
    owner "root"
    group "root"
    mode 0644
    content "local_root=#{new_resource.root}"
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end
end

action :remove do
  bash "Removing #{new_resource.username} from vsftpd authentication" do
    code %{
      sed -i '/#{new_resource.username}.*/ d' #{node[:vsftpd][:user_passwd_file]}
    }
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end

  file "#{node[:vsftpd][:user_config_dir]}/#{new_resource.username}" do
    action :delete
    notifies :restart, resources(:service => "vsftpd"), :delayed
  end
end

def load_current_resource
  service "vsftpd" do
    supports :status => true, :stop => true, :start => true, :restart => true
  end

  file node[:vsftpd][:user_passwd_file] do
    owner "root"
    group "root"
    mode 0600
    action :create_if_missing
  end
end
