#
# Cookbook:: ftb_server
# Recipe:: mod_dynmap
#
# Copyright:: 2017, Stefan Wendler
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

include_recipe 'ftb_server::default'

install_base = node['ftb_server']['install_base']

pack_base_dir = node['ftb_server']['pack_base_dir']
pack_version = node['ftb_server']['pack']['version']
pack_version_dir = "#{install_base}.#{pack_version}"
pack_version_server_dir = ::File.join pack_base_dir, pack_version_dir

mods_dir = ::File.join pack_version_server_dir, 'mods'
ftb_group = node['ftb_server']['user']['group']
ftb_user = node['ftb_server']['user']['name']

rc_script = node['ftb_server']['rc_d']['name']


remote_file ::File.join mods_dir, 'dynmap.jar' do
  source node['ftb_server']['mod_dynmap']['jar_url']
  owner ftb_user
  group ftb_group
  mode '0644'
  action :create
  notifies :restart, "service[#{rc_script}]", :delayed if node['ftb_server']['mod_dynmap']['restart_on_update']
end
