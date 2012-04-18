package "shorewall kw" do
  action :install
end

execute "cleanup_enabled" do
  command "rm -f /etc/shorewall/rules-enabled-custom/*.chef.rule"
  action :run
end


unless node[:shorewall][:new_rules].nil?
  val=node[:shorewall][:new_rules].to_hash
  val.each do |name,rule|
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
  val=node[:shorewall][:enabled_rules].to_hash
  val.each do |pk,name|
    link "/etc/shorewall/rules-enabled/#{name}.chef.rule" do
      to "/etc/shorewall/rules-available/#{name}.rule"
    end
  end
end