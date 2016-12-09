#
# Cookbook Name:: ftb_server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

include_recipe 'ftb_server::prepare'
unless node['ftb_server']['installed']['pack'] == node['ftb_server']['pack']['name'] &&
    node['ftb_server']['installed']['version'] == node['ftb_server']['pack']['version']
  include_recipe 'ftb_server::install'
end
ruby_block do
  block do
    node.set['ftb_server']['installed']['version'] = node['ftb_server']['pack']['version']
    node.set['ftb_server']['installed']['pack'] = node['ftb_server']['pack']['name']
  end
end




