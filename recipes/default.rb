#
# Cookbook Name:: ftb_server
# Recipe:: default
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
## Default Recipe
#

chef_gem 'json'

include_recipe 'ftb_server::install'

# ruby_block 'set_version_and_pack_after_successful_install' do
#   block do
#     node.set['ftb_server']['installed']['version'] = node['ftb_server']['pack']['version']
#     node.set['ftb_server']['installed']['pack'] = node['ftb_server']['pack']['name']
#   end
# end




