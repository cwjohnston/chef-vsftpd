use_inline_resources

include Chef::DSL::IncludeRecipe

action :add do
  ruby_block "update #{new_resource }" do
    block do
      update
    end
    not_if { current_resource.exists }
  end

  directory new_resource.root do
    owner new_resource.local_user || node[:vsftpd][:guest_username]
    group current_resource.group
    recursive true
    mode new_resource.mode
  end

  template ::File.join(node[:vsftpd][:user_config_dir], new_resource.user) do
    source "vuser.config.erb"
    cookbook "vsftpd"
    owner "root"
    group "root"
    mode 0644
    variables(
      :root => new_resource.root.sub(%r!/\./.*!,''),
      :user => new_resource.local_user
    )
  end
end

action :remove do
  bash "Removing #{new_resource.user} from vsftpd authentication" do
    code %{
      sed -i '/#{new_resource.user}.*/ d' #{node[:vsftpd][:user_passwd_file]}
    }
  end

  file ::File.join(node[:vsftpd][:user_config_dir], new_resource.user) do
    action :delete
  end
end

def load_current_resource
  include_recipe "vsftpd::virtual_users"

  @current_resource = Chef::Resource::VsftpdUser.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.user(@new_resource.user)
  @current_resource.group(new_resource.group || current_resource.user)
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
