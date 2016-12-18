#
# Cookbook Name:: ftb_server
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

describe 'ftb_server::install' do
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

    it 'creates the system group at compile time' do
      expect(chef_run).to create_group('ftb').at_compile_time
    end

    it 'creates the system user at compile time' do
      expect(chef_run).to create_user('ftb').with(
          group: 'ftb',
          home: '/usr/local/ftb',
          manage_home: true,
          shell: '/bin/sh'
      ).at_compile_time
    end

    %w( /usr/local/ftb/FTBInfinityLite110/Server.1.3.3 /usr/local/ftb/FTBInfinityLite110/.Addon ).each do |pdir|
      it "creates #{pdir} at compile time" do
        expect(chef_run).to create_directory(pdir).with(owner: 'ftb', group: 'ftb', recursive: true, mode: '750').at_compile_time
      end
    end

    %w( openjdk8 tmux curl ).each do |pkg|
      it "installs package #{pkg}" do
        expect(chef_run).to install_package pkg
      end
    end

    it 'creates the rc-script' do
      expect(chef_run).to create_template('/usr/local/etc/rc.d/ftbserver').with(
          user: 'root',
          group: 'wheel',
          mode: '555',
          variables: ({
              ftb_server_home: '/usr/local/ftb/FTBInfinityLite110/Server.1.3.3',
              ftb_server_name: 'FTBInfinityLite110',
              ftb_user: 'ftb',
              ftb_world_name: 'world'
          })
      )
    end

    it 'creates symlink to the current version' do
      expect(chef_run).to create_link('/usr/local/ftb/FTBInfinityLite110/Server')
                              .with_to '/usr/local/ftb/FTBInfinityLite110/Server.1.3.3'
    end

    %w( world backups ).each do |dir|
      it "creates Addon directory #{dir}" do
        expect(chef_run).to create_directory('/usr/local/ftb/FTBInfinityLite110/.Addon/' + dir).with(
            owner: 'ftb',
            group: 'ftb',
            recursive: true,
            mode: '750'
        )
      end

      it "creates symlink for dir #{dir}" do
        expect(chef_run).to create_link('/usr/local/ftb/FTBInfinityLite110/Server.1.3.3/' + dir)
                                .with_to('/usr/local/ftb/FTBInfinityLite110/.Addon/' + dir)
      end
    end

    it 'downloads and extracts the FTB-Modpack' do
      expect(chef_run).to(
          unpack_poise_archive('http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinityLite110/1_3_3/FTBInfinityLite110Server.zip').with(
              destination: '/usr/local/ftb/FTBInfinityLite110/Server.1.3.3',
              user: 'ftb',
              group: 'ftb',
              keep_existing: true,
              strip_components: 0
          )
      )
    end
  end
end
