default['ftb_server']['openjdk_version'] = 8
default['ftb_server']['packages'] = %W( openjdk#{node['ftb_server']['openjdk_version']} tmux curl )

default['ftb_server']['install_base'] = 'Server'
default['ftb_server']['addon_dir'] = '.Addon'

default['ftb_server']['rc_d']['name'] = 'ftbserver'
default['ftb_server']['rc_d']['dir'] = '/usr/local/etc/rc.d'

## auto-restart server? Generally a good idea to do this once in a while to keep performance up
## and to minimize probems like memory leaks, unresponsive server, etc
default['ftb_server']['auto_restart']['enable'] = true
## Hash in the form: { minute: '0', hour: '5', day: '*', month: '*', weekday: '*' } where '*' is the default and can be
## left out of the hash
default['ftb_server']['auto_restart']['time'] = { minute: '0', hour: '5' }

default['ftb_server']['user']['name'] = 'ftb'
default['ftb_server']['user']['group'] = 'ftb'
default['ftb_server']['user']['shell'] = '/bin/sh'
default['ftb_server']['user']['home'] = '/usr/local/ftb'

# Every file in this array will be symlinked to the FTB dir
default['ftb_server']['addon_config']['files'] = %w( whitelist.json ops.json banned-ips.json banned-players.json )

## We have to accept the Minecraft eula to be able to start the FTB Server
default['ftb_server']['eula']['do_accept'] = true

default['ftb_server']['settings_local_sh']['java_cmd'] = 'java'
default['ftb_server']['settings_local_sh']['xms'] = '2G'
default['ftb_server']['settings_local_sh']['xmx'] = '5G'
default['ftb_server']['settings_local_sh']['permgen_size'] = '256M'
default['ftb_server']['settings_local_sh']['java_parameters'] = %w(
                                                                    -XX:+UseParNewGC
                                                                    -XX:+CMSIncrementalPacing
                                                                    -XX:+CMSClassUnloadingEnabled
                                                                    -XX:ParallelGCThreads=2
                                                                    -XX:MinHeapFreeRatio=5
                                                                    -XX:MaxHeapFreeRatio=10
                                                                  )
# if false, the server might not start because of changed blocks during version upgrade
# you may leave this false but then you have to connect to the server console and /fml confirm manually
default['ftb_server']['fml']['add_confirm_option'] = true
default['ftb_server']['fml']['confirm_option'] = '-Dmfl.queryRestult=confirm'

default['ftb_server']['server_properties']['spawn_protection'] = 16
default['ftb_server']['server_properties']['max_tick_time'] = 60000
default['ftb_server']['server_properties']['generator_settings'] = ''
default['ftb_server']['server_properties']['force_gamemode'] = true
default['ftb_server']['server_properties']['allow_nether'] = true
default['ftb_server']['server_properties']['gamemode'] = 0
default['ftb_server']['server_properties']['broadcast_console_to_ops'] = true
default['ftb_server']['server_properties']['enable_query'] = false
default['ftb_server']['server_properties']['player_idle_timeout'] = 0
default['ftb_server']['server_properties']['difficulty'] = 1
default['ftb_server']['server_properties']['spawn_monsters'] = true
default['ftb_server']['server_properties']['op_permission_level'] = 4
default['ftb_server']['server_properties']['announce_player_achievements'] = true
default['ftb_server']['server_properties']['pvp'] = true
default['ftb_server']['server_properties']['snooper_enabled'] = true
default['ftb_server']['server_properties']['level_type'] = 'BIOMESOP'
default['ftb_server']['server_properties']['hardcore'] = false
default['ftb_server']['server_properties']['enable_command_block'] = false
default['ftb_server']['server_properties']['max_players'] = 20
default['ftb_server']['server_properties']['network_compression_threshold'] = 256
default['ftb_server']['server_properties']['resource_pack_sha1'] = ''
default['ftb_server']['server_properties']['max_world_size'] = 29999984
default['ftb_server']['server_properties']['server_port'] = 25565
default['ftb_server']['server_properties']['texture_pack'] = ''
default['ftb_server']['server_properties']['server_ip'] = node['ipaddress']
default['ftb_server']['server_properties']['spawn_npcs'] = true
default['ftb_server']['server_properties']['allow_flight'] = true
default['ftb_server']['server_properties']['level_name'] = 'world'
default['ftb_server']['server_properties']['view_distance'] = 12
default['ftb_server']['server_properties']['resource_pack'] = ''
default['ftb_server']['server_properties']['spawn_animals'] = true
default['ftb_server']['server_properties']['white_list'] = true
default['ftb_server']['server_properties']['generate_structures'] = true
default['ftb_server']['server_properties']['online_mode'] = true
default['ftb_server']['server_properties']['max_build_height'] = 256
default['ftb_server']['server_properties']['level_seed'] = '2323115871908605002'
# Minecraft will escape characters like !, = etc so we might as well escape them here to prevent rewrite of the config with every chef run
default['ftb_server']['server_properties']['motd'] = 'Be nice to each other\! NO griefing\!\!'
default['ftb_server']['server_properties']['enable_rcon'] = false

## other options for server.properties, like {'my-property' => 'value', ...}
default['ftb_server']['server_properties']['additional_options'] = {}

## http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinityLite110/1_3_3/FTBInfinityLite110Server.zip
default['ftb_server']['pack']['base_url'] = 'http://ftb.cursecdn.com/FTB2/modpacks'
default['ftb_server']['pack']['name'] = nil
default['ftb_server']['pack']['version'] = nil

default['ftb_server']['start_server'] = true

default['ftb_server']['mod_dynmap']['jar_url'] = 'http://addons.curse.cursecdn.com/files/2307/83/Dynmap-2.3-forge-1.9.4.jar' #(rename to dynmap.jar locally)
#default['ftb_server']['mod_dynmap']['config'][<params>] - properties

## Set by Cookbook. Do NOT edit!
default['ftb_server']['installed']['pack'] = nil
default['ftb_server']['installed']['version'] = nil

## Don't change these attributes!
default['ftb_server']['pack_base_dir'] = ::File.join node['ftb_server']['user']['home'], node['ftb_server']['pack']['name']
default['ftb_server']['pack_addon_dir'] = ::File.join node['ftb_server']['pack_base_dir'], node['ftb_server']['addon_dir']
