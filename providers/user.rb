action :add do
  execute "Adding #{new_resource.username} to Apache authentication" do
    command %{
      if [ $(grep -c #{htdigest.first} #{new_resource.passwd_file}) -gt 0 ]; then
        sed -i 's/#{htdigest.first}.*/#{htdigest}/g' #{new_resource.passwd_file}
      else
        echo #{htdigest} >> #{new_resource.passwd_file}
      fi
    }
    only_if "[ $(egrep -c '#{htdigest}$' #{new_resource.passwd_file}) -eq 0 ]"
  end
end

action :remove do
  execute "Removing #{new_resource.username} from Apache authentication" do
    command %{
      sed -i '/#{htdigest.first}.*/ d' #{new_resource.passwd_file}
    }
  end
end

def load_current_resource
  extend Apache2::Passwd

  file new_resource.passwd_file do
    mode "0644"
    owner "root"
    group "root"
    action :create_if_missing
    backup false
  end
end
