ftb_group = node['ftb_server']['user']['group']
ftb_user = node['ftb_server']['user']['name']
ftb_home = node['ftb_server']['user']['home']

install_base = node['ftb_server']['install_base']

node['ftb_server']['packages'].each do |pkg|
  freebsd_package pkg
end

group ftb_group

user ftb_user do
  group ftb_group
  home ftb_home
  manage_home true
  shell node['ftb_server']['user']['shell']
  action :create
end

pack_base_dir = ::File.join(ftb_home, node['ftb_server']['pack']['name'])
pack_version_dir = ::File.join("#{install_base}.", node['ftb_server']['pack']['version'])

pack_server_version_dir = ::File.join(pack_base_dir, pack_version_dir)
pack_addon_dir = ::File.join(pack_base_dir, '.Addon')

[pack_server_version_dir, pack_addon_dir].each do |pdir|
  directory pdir do
    owner ftb_user
    group ftb_group
    recursive true
    mode '750'
  end
end