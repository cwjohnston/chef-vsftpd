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
