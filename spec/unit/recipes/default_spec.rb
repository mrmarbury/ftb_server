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

describe 'ftb_server::default' do
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

    it 'installs the json gem' do
      expect(chef_run).to install_chef_gem('json').with(compile_time: false)
    end

    it 'includes the install recipe' do
      expect(chef_run).to include_recipe 'ftb_server::install'
    end

    # This is okay for now since the values are informational only.
    # I might change this later to really check the values before and after
    it 'executes a ruby block that sets installed pack and version info' do
      expect(chef_run).to run_ruby_block 'set_version_and_pack_info'
    end
  end
end
