# ftb_server

**INFO: This CB is in bad shape. It works but there are no tests and the README is outdated**

Chef Cookbook to manage a "Feed the Beast"-Server installation on FreeBSD.

## Requirements

### Platforms

 * FreeBSD-10.3+
 
### Chef

 * Chef-12.1+
 
### Dependent Cookbooks

 * poise_archive-1.5.0+
 * poise-monit-1.6.0+
 
## General Info On The How And Why

The FTB-Server installation is devided into three parts:

 1. The user/group and its home-dir
 2. The FTB-Pack main directory and each version
 3. The files/directories that contain world data, backup, and config that are symlinked into each version-dir
 
An installed FTB-Server will have the following directory structure:

```
/usr/local/<user>/<pack>
                       \_ Server.A.B.C
                                     \_ installation_files/directories
                                     \_ server.properties
                                     \_ symliked files/directories from .Addon
                       \_ Server.D.E.F
                                     \_ installation_files/directories
                                     \_ server.properties
                                     \_ symliked files/directories from .Addon
                       \_ Server #symlink to current version_dir for informational purposes
                       \_ .Addon
                               \_ ops.json
                               \_ whitelist.json
                               \_ banned-ips.json
                               \_ banned-players.json
                               \_ world/
                               \_ backups/
                               \_ ...
                               
/usr/local/etc/rc.d/ftbserver
```

The JSON-Files cannot be delivered easily as templates since they are updated through Minecraft. 
So you will have to manage them yourself in a wrapping Cookbook (or similar - see **Usage** below) and put them into the `.Addon`-directory
yourself. The Cookbook will then symlink these files to the current Server-directory. The `world`- and `backups`-directories will only
be created and then symlinked. That way the current world and backups will be available with every version within the installed pack.
For every new pack-version a new directory will be created that is called `Server.<version>` by default. And then a symlink named `Server`
will be created that points to the currently active installation. This symlink is for informational purposes only since it serves
no technical purpose in this Cookbook.

## Attributes

### General

 - `node['ftb_server']['openjdk_version']` - Which OpenJDK version to install. Default: `8`
 - `node['ftb_server']['packages']` - Array of packages that have to be installed prior to rolling out the FTB server. Default: `%W( openjdk#{node['ftb_server']['openjdk_version']} tmux curl )`
 - `node['ftb_server']['install_base']` - Base directory name for an installation. Default: `'Server'`
 - `node['ftb_server']['addon_dir']` - Name of the directory that will contain all symlinked files. Default: `'.Addon'`
 - `node['ftb_server']['start_server']` - Whether to enable and start the server or not. Default: `true`
 
### rc-Script

 - `node['ftb_server']['rc_d']['name']` - Name of the service. Default: `'ftbserver'`
 - `node['ftb_server']['rc_d']['path']` - Path to the rc-script. Default: `'/usr/local/etc/rc.d'`

### User/Group

 - `node['ftb_server']['user']['name']` - The system user. Default: `'ftb'`
 - `node['ftb_server']['user']['group']` - The user's system group. Default: `'ftb'`
 - `node['ftb_server']['user']['shell']` - Login shell of the system user. Default: `'/bin/sh'`
 - `node['ftb_server']['user']['home']` - Home directory of the system user. This is also where the FTB installations will be made. Default: `'/usr/local/ftb'`

### Addon Config

 - `node['ftb_server']['addon_config']['files']` - Array with the config files that will be symlinked to the current version's directory.
  Only files in that Array are symlinked. The reason for this is that this directory may contain other files you do not want to symlink.
  Default: `%w( whitelist.json ops.json banned-ips.json banned-players.json )`

### eula.txt-File

 - `node['ftb_server']['eula']['do_accept']` - We have to accept the Minecraft eula to be able to start the FTB Server. If you set this to `false` then the server won't start. Default `true`

### settings-local.sh-File

 - `node['ftb_server']['settings_local_sh']['java_cmd']` - The name of the java binary. Default: `'java'`
 - `node['ftb_server']['settings_local_sh']['xms']` - The Java XMS value. Default `'2G'`
 - `node['ftb_server']['settings_local_sh']['xmx']` - The Java XMX value. Default: `'8G'`
 - `node['ftb_server']['settings_local_sh']['permgen_size']` - Java's PermGen Size. Default: `'256M'`
 - `node['ftb_server']['settings_local_sh']['java_parameters']` - Array with Java parameters. Default: 
 
 ```
 %w(
    -XX:+UseParNewGC
    -XX:+CMSIncrementalPacing
    -XX:+CMSClassUnloadingEnabled
    -XX:ParallelGCThreads=2
    -XX:MinHeapFreeRatio=5
    -XX:MaxHeapFreeRatio=10
 )
 ```
 
### FML-Confirm

 - `node['ftb_server']['fml']['add_confirm_option']` - Whether to confirm world/block-changes that might occur during server update. If this is `false` the server might not start and will wait for user interaction.
  Default: `true`
 - `node['ftb_server']['fml']['confirm_option']` - The Java parameter for FML-Confirm. Default: `'-Dmfl.queryResult=confirm'`

### server.properties-File

The following attributes are the server.peoperties attributes with the same name. The attributes are not explained any further. Only the default
values and a hint will be shown next to the attribute

 - `node['ftb_server']['server_properties']['spawn_protection']` - Default: `16`
 - `node['ftb_server']['server_properties']['max_tick_time']` - Default: `60000`
 - `node['ftb_server']['server_properties']['generator_settings']` - Default: `''`
 - `node['ftb_server']['server_properties']['force_gamemode']` - Default: `true`
 - `node['ftb_server']['server_properties']['allow_nether']` - Default: `true`
 - `node['ftb_server']['server_properties']['gamemode']` - Default: `0`
 - `node['ftb_server']['server_properties']['broadcast_console_to_ops']` - Default: `true`
 - `node['ftb_server']['server_properties']['enable_query']` - Default: `false`
 - `node['ftb_server']['server_properties']['player_idle_timeout']` - Default: `0`
 - `node['ftb_server']['server_properties']['difficulty']` - Default: `1`
 - `node['ftb_server']['server_properties']['spawn_monsters']` - Default: `true`
 - `node['ftb_server']['server_properties']['op_permission_level']` - Default: `4`
 - `node['ftb_server']['server_properties']['announce_player_achievements']` - Default: `true`
 - `node['ftb_server']['server_properties']['pvp']` - Default: `true`
 - `node['ftb_server']['server_properties']['snooper_enabled']` - Default: `true`
 - `node['ftb_server']['server_properties']['level_type']` - Default: `'BIOMESOP'`
 - `node['ftb_server']['server_properties']['hardcore']` - Default: `false`
 - `node['ftb_server']['server_properties']['enable_command_block']` - Default: `false`
 - `node['ftb_server']['server_properties']['max_players']` - Default: `20`
 - `node['ftb_server']['server_properties']['network_compression_threshold']` - Default: `256`
 - `node['ftb_server']['server_properties']['resource_pack_sha1']` - Default: `''`
 - `node['ftb_server']['server_properties']['max_world_size']` - Default: `29999984`
 - `node['ftb_server']['server_properties']['server_port']` - Default: `25565`
 - `node['ftb_server']['server_properties']['texture_pack']` - Default: `''`
 - `node['ftb_server']['server_properties']['server_ip']` - Default: `node['ipaddress']`
 - `node['ftb_server']['server_properties']['spawn_npcs']` - Default: `true`
 - `node['ftb_server']['server_properties']['allow_flight']` - Default: `true`
 - `node['ftb_server']['server_properties']['level_name']` - Default: `'world'`
 - `node['ftb_server']['server_properties']['view_distance']` - Default: `12`
 - `node['ftb_server']['server_properties']['resource_pack']` - Default: `''`
 - `node['ftb_server']['server_properties']['spawn_animals']` - Default: `true`
 - `node['ftb_server']['server_properties']['white_list']` - Default: `true`
 - `node['ftb_server']['server_properties']['generate_structures']` - Default: `true`
 - `node['ftb_server']['server_properties']['online_mode']` - Default: `true`
 - `node['ftb_server']['server_properties']['max_build_height']` - Default: `256`
 - `node['ftb_server']['server_properties']['level_seed']` - Default: `'2323115871908605002'` (my favorite seed)
 - `node['ftb_server']['server_properties']['motd']` - Minecraft will escape characters like !, = etc so we might as well escape them here to prevent 
 rewrite of the config with every chef run. Will get the current version and pack name prepended to it automatically. Default: `'Be nice to each other\! NO griefing\!\!'`
 - `node['ftb_server']['server_properties']['enable_rcon']` - Default: `false`
 - `node['ftb_server']['server_properties']['additional_options']` - Hash that can contain any other server.properties option not listed above in the form
 `{'my-property' => 'value'}`. Default: `{}`

### Pack Related

 - `node['ftb_server']['pack']['base_url']` - Base URL where the FTB Server packs can be found. If a Forge pack is installed then this has to resemble the complete download URL where the downloaded file has a suffix like .zip. You also have to set the 'is_forge_pack'parameter to `true`. Default: `'http://ftb.cursecdn.com/FTB2/modpacks'`
 - `node['ftb_server']['pack']['name']` - FTB modpack name. Has to be equal to the packs subdirectory on the download server. It is basically the FTB pack name without the spaces but in camel case. For example if the pack is named 'FTB Infinity Lite 110' then the name here has to be 'FTBInfinityLite110'.
  If a Forge pack is installed then the parameter can be set to any name you like. Must be set on a role/environment. Default: `nil`
 - `node['ftb_server']['pack']['version']` - Version of the FTB modpack in the form `X.Y.Z`. If you install a Forge pack then this value must match the version of the Forge Pack in the form `X.Y.Z.`. It is then still used to determine if the server is eligible for upgrade/downgrade. Must be set in a role/environment. Default: `nil`
 - `node['ftb_server']['pack']['is_forge_pack']` - Set this to `true`, if you install a Forge pack instead of a FTB pack. The parameters for `base_url`, `name`, and `version` will the be treated differently. See above. Default: `false`
 
### mod_dynmap-Recipe

 - `node['ftb_server']['mod_dynmap']['jar_url']` - URL to the Forge Version of the Dynmap jar-file. Default: `'https://addons-origin.cursecdn.com/files/2436/596/Dynmap-2.6-beta-1-forge-1.12.jar'`
 - `node['ftb_server']['mod_dynmap']['restart_on_update']` - Set this to `true` to restart the server, when a new dynmap version has been installed. Default `false`
 
### auto_restart-Recipe

 - `node['ftb_server']['auto_restart']['enable']` - It is a good idea to restart a Minecraft server in regular intervals. Setting this to `true` will create
  a cronjob that does exactly this. Default: `true`
 - `node['ftb_server']['auto_restart']['time']` - The time at which the server gets restarted. Default: `{ minute: '0', hour: '5' }`. 
 See Chef's [cron](https://docs.chef.io/resource_cron.html) resource for more info. Possible keys are: `:weekday, :month, :day, :hour, :minute, :time`

## Usage

### Standalone

 - Add `ftb_server::default` to your Nodes run list 
 - Add pack name and version to your role/environment. Role-Example:
 
 ```ruby
 override_attributes({
   "ftb_server" => {
       "pack" => {
           "name" => "FTBInfinityLite110",
           "version" => "1.3.3"
       }
   }
 })
 ```
 
### In a wrapper-cookbook with managed JSON-Files

 - Put your JSON-Files into the files-directory of your wrapper cookbook (See 'Addon Config' above for the default files that are configured in the array. Override for different files, if you know better)
 - Add the following to your wrapper Cookbooks `default.rb`

```ruby
node['ftb_server']['addon_config']['files'].each do |file|
  cookbook_file ::File.join(node['ftb_server']['pack_addon_dir'], file) do
    source file
    owner node['ftb_server']['user']['name']
    group node['ftb_server']['user']['group']
    mode '644'
  end
end

include_recipe 'ftb_server::default'
```
 
 - Add pack name and version to your role/environment. Role-Example:
 
     ```ruby
     override_attributes({
       "ftb_server" => {
           "pack" => {
               "name" => "FTBInfinityLite110",
               "version" => "1.3.3"
           }
       }
     })
     ```

## Recipes

### ftb_server::default

Add this recipe to your run list and set the needed attributes to get going

### ftb_server::install

Gets the pack going. Included in the Default-Recipe

### ftb_server::auto_restart

Creates a cronjob that restarts the server periodically, if `node['ftb_server']['auto_restart']['enable']` is true

### ftb_server::mod_dynmap

Installs the dynmap plugin. 

**INFO: WIP! It currently only puts the jar-file in place and triggers a restart of the server, if needed. There is no real config yet**

## How to Test

### Specs

Run command `rspec` from the root of this Cookbook

### Integration tests

**INFO: Not Yet Implementred**

 1. Install Vagrant with berkshelf and testkitchen plugins
 1. Install VirtualBox and configure it according to your OS's documentation
 1. Run `kitchen test`
 
## License and Authors

Author: Stefan Wendler (<stefan@binarysun.de>)
License: Apache License, Version 2.0 (January 2004 - http://www.apache.org/licenses/)

