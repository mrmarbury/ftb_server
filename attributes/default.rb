default['ftb_server']['openjdk_version'] = 8
default['ftb_server']['packages'] = %W( openjdk#{node['ftb_server']['openjdk_version']} tmux curl )

default['ftb_server']['install_base'] = 'Server'
default['ftb_server']['addon_dir'] = '.Addon'

## auto-restart server? weekday is either nil for daily or valid cron syntax, like: 1, 1-5, */2, etc
default['ftb_server']['auto_restart']['enable'] = false
## Hash in the form: { minute: '0', hour: '5', day: '*', month: '*', weekday: '*' } where '*' is the default can be left out
## of the hash
default['ftb_server']['auto_restart']['time'] = { minute: '0', hour: '5' }

default['ftb_server']['user']['name'] = 'ftb'
default['ftb_server']['user']['group'] = 'ftb'
default['ftb_server']['user']['shell'] = '/bin/sh'
default['ftb_server']['user']['home'] = '/usr/local/ftb'

## We have to accept the Minecraft eula to be able to start the FTB Server
default['ftb_server']['eula']['do_accept'] = true

default['ftb_server']['settings_local_sh']['java_cmd'] = 'java'
default['ftb_server']['settings_local_sh']['xms'] = '2G'
default['ftb_server']['settings_local_sh']['xmx'] = '5G'
default['ftb_server']['settings_local_sh']['permgem_size'] = '256M'
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
default['ftb_server']['settings_local_sh']['add_fml_confirm_option'] = true

default['ftb_server']['server_properties']['spawn-protection'] = 16
default['ftb_server']['server_properties']['max-tick-time'] = 60000
default['ftb_server']['server_properties']['generator-settings'] = ''
default['ftb_server']['server_properties']['force-gamemode'] = true
default['ftb_server']['server_properties']['allow-nether'] = true
default['ftb_server']['server_properties']['gamemode'] = 0
default['ftb_server']['server_properties']['broadcast-console-to-ops'] = true
default['ftb_server']['server_properties']['enable-query'] = false
default['ftb_server']['server_properties']['player-idle-timeout'] = 0
default['ftb_server']['server_properties']['difficulty'] = 1
default['ftb_server']['server_properties']['spawn-monsters'] = true
default['ftb_server']['server_properties']['op-permission-level'] = 4
default['ftb_server']['server_properties']['announce-player-achievements'] = true
default['ftb_server']['server_properties']['pvp'] = true
default['ftb_server']['server_properties']['snooper-enabled'] = true
default['ftb_server']['server_properties']['level-type'] = 'BIOMESOP'
default['ftb_server']['server_properties']['hardcore'] = false
default['ftb_server']['server_properties']['enable-command-block'] = false
default['ftb_server']['server_properties']['max-players'] = 20
default['ftb_server']['server_properties']['network-compression-threshold'] = 256
default['ftb_server']['server_properties']['resource-pack-sha1'] = nil
default['ftb_server']['server_properties']['max-world-size'] = 29999984
default['ftb_server']['server_properties']['server-port'] = 25565
default['ftb_server']['server_properties']['texture-pack'] = nil
default['ftb_server']['server_properties']['server-ip'] = nil
default['ftb_server']['server_properties']['spawn-npcs'] = true
default['ftb_server']['server_properties']['allow-flight'] = true
default['ftb_server']['server_properties']['level-name'] = 'world'
default['ftb_server']['server_properties']['view-distance'] = 12
default['ftb_server']['server_properties']['resource-pack'] = nil
default['ftb_server']['server_properties']['spawn-animals'] = true
default['ftb_server']['server_properties']['white-list'] = true
default['ftb_server']['server_properties']['generate-structures'] = true
default['ftb_server']['server_properties']['online-mode'] = true
default['ftb_server']['server_properties']['max-build-height'] = 256
default['ftb_server']['server_properties']['level-seed'] = '2323115871908605002'
default['ftb_server']['server_properties']['motd'] = 'Be nice to each other! NO griefing!!'
default['ftb_server']['server_properties']['enable-rcon'] = false

## other options for server.properties, like {'my-property' => 'value', ...}
default['ftb_server']['server_properties']['additional_options'] = {}

## http://ftb.cursecdn.com/FTB2/modpacks/FTBInfinityLite110/1_3_3/FTBInfinityLite110Server.zip
default['ftb_server']['pack']['base_url'] = 'http://ftb.cursecdn.com/FTB2/modpacks'
default['ftb_server']['pack']['name'] = 'FTBInfinityLite110'
default['ftb_server']['pack']['version'] = '1.3.3'

default['ftb_server']['start_server'] = true

default['ftb_server']['mod_dynmap']['jar_url'] = 'http://addons.curse.cursecdn.com/files/2307/83/Dynmap-2.3-forge-1.9.4.jar' #(rename to dynmap.jar locally)
#default['ftb_server']['mod_dynmap']['config'][<params>] - properties

## Set by Cookbook. Do NOT edit!
default['ftb_server']['installed']['pack'] = nil
default['ftb_server']['installed']['version'] = nil
