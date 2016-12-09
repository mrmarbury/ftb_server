# ftb_server

Chef Cookbook to manage a "Feed the Beast"-Server installation on FreeBSD.

## Supports

 * FreeBSD >= 10.3

## Attributes

node['ftb_server']['openjdk_version'] - OpenJDK version to install. Default: '8'
node['ftb_server']['user']['name'] - The local user that will run the server. Default: 'mcserver'
node['ftb_server']['user']['group'] - The group the user belongs to. Default: 'mcserver'
node['ftb_server']['user']['shell'] - The shell of the user. Default: '/bin/sh'

node['ftb_server']['server_properties']['motd'] = 'a friendly text'
node['ftb_server']['server_properties']['seed'] = '92349724928374'
node['ftb_server']['server_properties'][<other_stuff>] - all other props

node['ftb_server']['pack']['base_url'] - The base url that contains the packs. Default: 'http://www.creeperrepo.net/FTB2/modpacks'
node['ftb_server']['pack']['name'] - The Name of the pack on the Server. This is the directory name. Default: 'FTBInfinityLite110'
node['ftb_server']['pack']['version'] - The version of the Pack to install. You can set it in the classic manner, like '1.2.0'. Or you define it like so '1_2_0'. Since both variants are needed, we will transform the dots and underscores accordingly.

node['ftb_server']['start_server'] - Do you want to start the Server process, after the installation? Default: true

node['ftb_server']['start_script']['xms'] = '2G'
node['ftb_server']['start_script']['xmx'] = '4G'
node['ftb_server']['start_script']['add_fml_confirm_option'] = true (if false, server might not start up because of changed blocks)

node['ftb_server']['mod_dynmap']['do_setup'] = true
node['ftb_server']['mod_dynmap']['jar_url'] = 'http://addons.curse.cursecdn.com/files/2307/83/Dynmap-2.3-forge-1.9.4.jar' (rename to dynmap.jar locally)
node['ftb_server']['mod_dynmap']['config'][<params>] - properties

Complete URL would then be: 'http://www.creeperrepo.net/FTB2/modpacks/FTBInfinityLite110/1_2_0/FTBInfinityLite110Server.zip'

## How it works

Condition for the steps might be: version does not match (maybe check for Server.version-Dir?)

 1. stops server, if running (kills process with pid from pid file and checks if pid gone, deletes pid file. else: raise Error)
 1. OpenJDK is installed and current
 1. TMUX is installed and current
 1. Curl is installed and current:
 1. The user and ins home dir is created
 1. Creates the FTBServer Home dir that is named after 'pack_name'
 1  Creates .Addons Dir in FTBServer Home with subdirs: world, backups, dynmap(if wanted)
 1. Creates Server.version dir inside FTBServer Home Dir
 1. Downloads and extracts the FTB-Server.zip inside Server.version dir
 1. Puts several templates in place (server.properties, eula)
  1. server.properties
   1. motd will contain version, pack_name and motd-property.
   1. seed is setable
   1. mostly all other properties
  1. eula: set to true
 1. Rollout ServerStart.sh with xms, xmx and fml.confirm
 1. Puts mods in files/mods in place (e.g. Dynmap, if wanted)
 1. Puts config in files/config in place (e.g. Dynmap config, if wanted)
 1. configure mods
  1. Dynmap: config as template, jar from url
 1. Puts an rc-script in place and configures it in rc.conf (opens a tmux and calls ServerStart.sh in server directory, writes pid file)
 1. Starts server

## Usage

Add `ftb_server::default` to your Nodes run list

## Recipes

### ftb_server::default

Add this recipe to your run list and set the needed attributes to get going

### ftb_server::prepare

Creates base dirs/files

### ftb_server::install

Gets the pack going

### ftb_server::auto_restart

Creates a cronjob that restarts the server periodically, if enable is true

### ftb_server::mod_dynmap

Installs and configures dynmap

## License and Authors

Author: Stefan Wendler (<stefan@binarysun.de>)
License: Apache License, Version 2.0 (January 2004 - http://www.apache.org/licenses/)

