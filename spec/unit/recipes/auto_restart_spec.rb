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

describe 'ftb_server::auto_restart' do
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'freebsd', version: '10.3') do |node|
        node.automatic['ftb_server']['pack']['name'] = 'FTBInfinityLite110'
        node.automatic['ftb_server']['pack']['version'] = '1.3.3'
        node.override['ftb_server']['auto_restart']['time'] = { minute: '1', hour: '2', day: '3', month: '4', weekday: '5', time: :daily }
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the default recipe' do
      expect(chef_run).to include_recipe 'ftb_server::default'
    end

    it 'creates the cronjob' do
      expect(chef_run).to create_cron('ftbserver_auto_restart').with(
          minute: '1',
          hour: '2',
          day: '3',
          month: '4',
          weekday: '5',
          time: :daily,
          command: '/usr/local/etc/rc.d/ftbserver onerestart',
          user: 'root',
          shell: '/bin/sh'
      )
    end
  end
end
