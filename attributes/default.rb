default['ftb_server']['openjdk_version'] = 8
default['ftb_server']['packages'] = %W( openjdk#{node['ftb_server']['openjdk_version']} tmux curl )

default['ftb_server']['install_base'] = 'Server'

default['ftb_server']['user']['name'] = 'ftb'
default['ftb_server']['user']['group'] = 'ftb'
default['ftb_server']['user']['shell'] = '/bin/sh'
default['ftb_server']['user']['home'] = '/usr/local/ftb'

default['ftb_server']['server_properties']['motd'] = 'a friendly text'
default['ftb_server']['server_properties']['seed'] = '92349724928374'
#default['ftb_server']['server_properties'][<other_stuff>] - all other props

default['ftb_server']['pack']['base_url'] = 'http://www.creeperrepo.net/FTB2/modpacks'
default['ftb_server']['pack']['name'] = 'FTBInfinityLite110'
default['ftb_server']['pack']['version'] = '1.3.3'

default['ftb_server']['start_server'] = true

default['ftb_server']['start_script']['xms'] = '2G'
default['ftb_server']['start_script']['xmx'] = '4G'
default['ftb_server']['start_script']['add_fml_confirm_option'] = true #(if false, server might not start up because of changed blocks)

default['ftb_server']['mod_dynmap']['do_setup'] = true
default['ftb_server']['mod_dynmap']['jar_url'] = 'http://addons.curse.cursecdn.com/files/2307/83/Dynmap-2.3-forge-1.9.4.jar' #(rename to dynmap.jar locally)
#default['ftb_server']['mod_dynmap']['config'][<params>] - properties