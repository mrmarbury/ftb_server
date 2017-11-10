#
# Cookbook Name:: ftb_server
# Recipe:: monit
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
#
attrs = node['ftbserver']['monit']

include_recipe 'ftb_server::default'
include_recipe 'poise_monit' if attrs['enable']

monit_config 'mailconfig' do
  content <<-EOH
    SET MAILSERVER #{attrs['mail_server']}
    SET ALERT #{attrs['mail_address']}
  EOH
  only_if { attrs['enable'] && attrs['do_mailconfig'] }
end

monit 'monit' do
  daemon_interval attrs['daemon_interval']
  event_slots attrs['event_slots']
  httpd_port attrs['http_port']
  httpd_username attrs['http_username']
  httpd_password attrs['http_password']
  action (attrs['enable']) ? [:enable, :start] : [:disable, :stop]
end



