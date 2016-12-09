#
# Cookbook Name:: ftb_server
# Recipe:: install
#
# Copyright:: 2016, Stefan Wendler
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
## Installing FTB Server
#

ftb_group = node['ftb_server']['user']['group']
ftb_user = node['ftb_server']['user']['name']
ftb_home = node['ftb_server']['user']['home']

install_base = node['ftb_server']['install_base']

pack_base_dir = ::File.join(ftb_home, node['ftb_server']['pack']['name'])
pack_version_dir = "#{install_base}.#{node['ftb_server']['pack']['version']}"

pack_version_server_dir = ::File.join(pack_base_dir, pack_version_dir)
pack_addon_dir = ::File.join(pack_base_dir, node['ftb_server']['addon_dir'])

node['ftb_server']['packages'].each do |pkg|
  package pkg
end

group ftb_group

user ftb_user do
  group ftb_group
  home ftb_home
  manage_home true
  shell node['ftb_server']['user']['shell']
end

[pack_version_server_dir, pack_addon_dir].each do |pdir|
  directory pdir do
    owner ftb_user
    group ftb_group
    recursive true
    mode '750'
  end
end

link ::File.join(pack_base_dir, 'Server') do
  to pack_version_server_dir
end

## making sure the linkable dirs for persistent data exist and are linked to the Server dir
[node['ftb_server']['server_properties']['level-name'], 'backups'].each do |addon_dir|
  pack_addon_path = ::File.join(pack_addon_dir, addon_dir)

  directory pack_addon_path do
    owner ftb_user
    group ftb_group
    recursive true
    mode '750'
  end

  link ::File.join(pack_version_server_dir, addon_dir) do
    to pack_addon_path
  end
end

pack_url = node['ftb_server']['pack']['base_url'] + '/' +
           node['ftb_server']['pack']['name'] + '/' +
           node['ftb_server']['pack']['version'].tr('.', '_') + '/' +
           node['ftb_server']['pack']['name'] + 'Server.zip'

poise_archive pack_url do
  destination pack_version_server_dir
  user ftb_user
  group ftb_group
  keep_existing true
  strip_components 0
  not_if { ::File.exists?(::File.join(pack_version_server_dir, 'ServerStart.sh')) }
end

## Making ServerStart.sh executable
file ::File.join(pack_version_server_dir, 'ServerStart.sh') do
  mode '750'
end

