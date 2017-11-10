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

  pack_base = '/usr/local/ftb/FTBInfinityLite110'
  addon_dir = ::File.join pack_base, '.Addon'
  server_version_dir = ::File.join pack_base, 'Server.1.3.3'

  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3') do |node|
        node.automatic['ftb_server']['pack']['name'] = 'FTBInfinityLite110'
        node.automatic['ftb_server']['pack']['version'] = '1.3.3'
        node.automatic['ipaddress'] = '127.0.0.1'
        node.override['ftb_server']['server_properties']['generator_settings'] = 'gensetting'
        node.override['ftb_server']['server_properties']['resource_pack_sha1'] = '123456'
        node.override['ftb_server']['server_properties']['texture_pack'] = 'texture_pack'
        node.override['ftb_server']['server_properties']['resource_pack'] = 'resource_pack'
        node.override['ftb_server']['server_properties']['additional_options'] = { 'my-var' => '123', 'my-var-2' => '456'}
      end
      runner.converge(described_recipe)
    end

    before :each do
      allow(::File).to receive(:exists?).and_call_original
      %w( whitelist.json ops.json banned-ips.json banned-players.json ).each do |addon_file|
        allow(::File).to receive(:exists?).with(::File.join addon_dir, addon_file).and_return true
      end
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

    [server_version_dir, addon_dir].each do |pdir|
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
              ftb_name: 'ftbserver',
              ftb_server_home: server_version_dir,
              ftb_server_name: 'FTBInfinityLite110',
              ftb_user: 'ftb',
              ftb_world_name: 'world'
          })
      )
    end

    it 'creates symlink to the current version' do
      expect(chef_run).to create_link(::File.join(pack_base, 'Server'))
                              .with_to server_version_dir
    end

    %w( world backups ).each do |dir|
      it "creates Addon directory #{dir}" do
        expect(chef_run).to create_directory(::File.join(addon_dir, dir)).with(
            owner: 'ftb',
            group: 'ftb',
            recursive: true,
            mode: '750'
        )
      end

      it "creates symlink for dir #{dir}" do
        expect(chef_run).to create_link(::File.join(server_version_dir, dir))
                                .with_to(::File.join(addon_dir, dir))
      end
    end

    it 'downloads and extracts the FTB-Modpack' do
      expect(chef_run).to(
          unpack_poise_archive('http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinityLite110/1_3_3/FTBInfinityLite110Server.zip').with(
              destination: server_version_dir,
              user: 'ftb',
              group: 'ftb',
              keep_existing: true,
              strip_components: 0
          )
      )
    end

    it 'creates the eula.txt file' do
      expect(chef_run).to create_template(::File.join server_version_dir, '/eula.txt').with(
          source: 'eula.txt.erb',
          user: 'ftb',
          group: 'ftb',
          mode: '644',
          variables: ({
              accept_eula: true
          })
      )
    end

    it 'creates the server.properties file' do
      expect(chef_run).to create_template(::File.join server_version_dir, '/server.properties').with(
          source: 'server.properties.erb',
          user: 'ftb',
          group: 'ftb',
          mode: '644',
          variables: ({
              spawn_protection: 16,
              max_tick_time: 60000,
              generator_settings: 'gensetting',
              force_gamemode: true,
              allow_nether: true,
              gamemode: 0,
              broadcast_console_to_ops: true,
              enable_query: false,
              player_idle_timeout: 0,
              difficulty: 1,
              spawn_monsters: true,
              op_permission_level: 4,
              announce_player_achievements: true,
              pvp: true,
              snooper_enabled: true,
              level_type: 'BIOMESOP',
              hardcore: false,
              enable_command_block: false,
              max_players: 20,
              network_compression_threshold: 256,
              resource_pack_sha1: '123456',
              max_world_size: 29999984,
              server_port: 25565,
              texture_pack: 'texture_pack',
              server_ip: '127.0.0.1',
              spawn_npcs: true,
              allow_flight: true,
              level_name: 'world',
              view_distance: 12,
              resource_pack: 'resource_pack',
              spawn_animals: true,
              white_list: true,
              generate_structures: true,
              online_mode: true,
              max_build_height: 256,
              level_seed: '2323115871908605002',
              motd: 'v1.3.3 - FTBInfinityLite110 -\=- Be nice to each other\! NO griefing\!\!',
              enable_rcon: false,
              additional_options: { 'my-var' => '123', 'my-var-2' => '456'}
          })
      )
    end

    it 'creates settings-local.sh file' do
      expect(chef_run).to create_template(::File.join server_version_dir, '/settings-local.sh').with(
          source: 'settings-local.sh.erb',
          user: 'ftb',
          group: 'ftb',
          mode: '750',
          variables: ({
              java_cmd: 'java',
              xms: '2G',
              xmx: '8G',
              permgen_size: '256M',
              java_parameters: '-XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2' \
                               ' -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -Dmfl.queryRestult=confirm'
          })
      )
      #expect(chef_run.template(::File.join server_version_dir, '/settings-local.sh')).to notify('service[ftbserver]').to(:restart).delayed
    end

    %w( whitelist.json ops.json banned-ips.json banned-players.json ).each do |addon_file|
      it "symlinks #{addon_file} to the server directory" do
        expect(chef_run).to create_link(::File.join(server_version_dir, addon_file))
                                .with_to(::File.join(addon_dir, addon_file))
      end
    end

    it 'Makes ServerStart.sh executable' do
      expect(chef_run).to create_file(::File.join server_version_dir, '/ServerStart.sh').with_mode '750'
    end

    it 'enables and starts ftbserver' do
      expect(chef_run).to enable_service('ftbserver').with_supports(start: true, stop: true, restart: true)
      expect(chef_run).to start_service('ftbserver').with_supports(start: true, stop: true, restart: true)
    end
  end
end
