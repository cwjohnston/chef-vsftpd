#use_inline_resources

include Chef::DSL::IncludeRecipe

action :add do
  include_recipe "vsftpd"
 
  ruby_block "update #{new_resource }" do
    block do
      update
    end
    not_if { current_resource.exists }
    notifies :restart, "service[vsftpd]"
  end

  file ::File.join(node[:vsftpd][:user_config_dir], new_resource.user) do
    owner "root"
    group "root"
    mode 0644
    root = "local_root=#{new_resource.root.sub(%r!/\./.*!,'')}\n"
    user = "guest_username=#{new_resource.local_user}\n" unless new_resource.local_user.to_s.empty?
    content "#{root}#{user}"
    notifies :restart, "service[vsftpd]"
  end
end

action :remove do
  bash "Removing #{new_resource.user} from vsftpd authentication" do
    code %{
      sed -i '/#{new_resource.user}.*/ d' #{node[:vsftpd][:user_passwd_file]}
    }
    notifies :restart, "service[vsftpd]"
  end

  file ::File.join(node[:vsftpd][:user_config_dir], new_resource.user) do
    action :delete
    notifies :restart, "service[vsftpd]"
  end
end

def load_current_resource
  include_recipe "vsftpd"

  @current_resource = Chef::Resource::VsftpdUser.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.password(@new_resource.password)
  @current_resource.exists = true if already_there?(@current_resource.user, @current_resource.password)
end

def already_there?(user = @current_resource.user, password = @current_resource.password)
  fuser = parse_passwd_file(user)
  return false unless fuser && fuser['salt']
  cmd = "openssl passwd -1 -salt #{fuser['salt']} #{password}"
  pass = Mixlib::ShellOut.new(cmd).run_command.stdout.chomp
  Chef::Log.debug("generate pass #{pass} for #{user}")
  return fuser['pass'] == pass
end

def parse_passwd_file(user)
  begin
    line = ::File.readlines(node['vsftpd']['user_passwd_file']).select { |line| line =~ user_regex(user) }.first.chomp
  rescue
    return nil
  end
  Chef::Log.debug("user #{user} regexed line: #{line}")
  return nil unless line
  pass = line.split(':',2).last
  salt = pass.split('$')[2]
  ret = { "pass" => pass, "salt" => salt }
  Chef::Log.debug("Return #{ret.inspect} for #{user}")
  return ret
end

def user_regex(user)
  return /^#{user}:/
end

def update
  upf = Chef::Util::FileEdit.new(node['vsftpd']['user_passwd_file'])
  cmd = "openssl passwd -1 #{current_resource.password}"
  pass = Mixlib::ShellOut.new(cmd).run_command.stdout.chomp

  newline = [current_resource.user, pass].join(':')  

  upf.search_file_delete_line(user_regex(current_resource.user))
  upf.insert_line_if_no_match(user_regex(current_resource.user), newline)
  upf.write_file
end
