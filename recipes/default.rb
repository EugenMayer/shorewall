package "shorewall kw" do
  action :install
end

execute "cleanup_enabled" do
  command "rm -f /etc/shorewall/rules-enabled-custom/*.chef.rule"
  action :run
end


unless node[:shorewall][:new_rules].nil?
  node[:shorewall][:new_rules].each do |name,rule|
    template "/etc/shorewall/rules-enabled-custom/#{name}.chef.rule" do
      variables(
          :name => name,
          :body => rule
      )
      source "rule.erb"
    end
  end
end


execute "cleanup_enabled" do
  command "rm -f /etc/shorewall/rules-enabled/*.chef.rule"
  action :run
end

unless node[:shorewall][:enabled_rules].nil?
  node[:shorewall][:enabled_rules].each do |pk,name|
    link "/etc/shorewall/rules-enabled/#{name}.chef.rule" do
      to "/etc/shorewall/rules-available/#{name}.rule"
    end
  end
end