#
# Cookbook:: ftb_server
# Spec:: default
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

require 'spec_helper'

describe 'ftb_server::mod_dynmap' do
  pack_base = '/usr/local/ftb/FTBInfinityLite110'
  server_version_dir = ::File.join pack_base, 'Server.1.3.3'
  addon_dir = ::File.join pack_base, '.Addon'
  mods_dir = ::File.join server_version_dir, 'mods'

  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3') do |node|
        node.automatic['ftb_server']['pack']['name'] = 'FTBInfinityLite110'
        node.automatic['ftb_server']['pack']['version'] = '1.3.3'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'downloads dynmap and puts it into the mods directory' do
      expect(chef_run).to create_remote_file(::File.join(mods_dir, 'dynmap.jar')).with(
        source: 'https://addons-origin.cursecdn.com/files/2436/596/Dynmap-2.6-beta-1-forge-1.12.jar',
        owner: 'ftb',
        group: 'ftb',
        mode: '0644'
      )
    end

    dynmap_addon_dir = ::File.join(addon_dir, 'dynmap')
    it 'creates Addon directory for dynmap' do
      expect(chef_run).to create_directory(dynmap_addon_dir).with(
        owner: 'ftb',
        group: 'ftb',
        recursive: true,
        mode: '750'
      )
    end

    it 'creates symlink for dir dynmap' do
      expect(chef_run).to create_link(::File.join(server_version_dir, 'dynmap'))
        .with_to(dynmap_addon_dir)
    end

    it 'creates the configuration.txt' do
      expect(chef_run).to create_template(::File.join(dynmap_addon_dir, 'configuration.txt')).with(
        source: 'configuration.txt.erb',
        user: 'ftb',
        group: 'ftb',
        mode: '644',
        variables: {
          webpage_title: 'v1.3.3 - FTBInfinityLite110',
        }
      )
    end
  end
end
