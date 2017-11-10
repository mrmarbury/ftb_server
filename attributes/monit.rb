default['ftb_server']['monit']['do_mailconfig'] = false
default['ftb_server']['monit']['mail_server'] = 'localhost'
default['ftb_server']['monit']['mail_address'] = 'ftbserver@domain.org'

## Set to nil or false to disable httpd support
default['ftb_server']['monit']['http_port'] = 2812
## You might want to override these with vault values. Set Password to nil to disable authentication
default['ftb_server']['monit']['http_username'] = 'ftbserver'
default['ftb_server']['monit']['http_password'] = 'ftbserver'

default['ftb_server']['monit']['daemon_interval'] = 60
default['ftb_server']['monit']['event_slots'] = 1000
