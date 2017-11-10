## auto-restart server? Generally a good idea to do this once in a while to keep performance up
## and to minimize probems like memory leaks, unresponsive server, etc
default['ftb_server']['auto_restart']['enable'] = true
## Hash in the form: { minute: '0', hour: '5', day: '*', month: '*', weekday: '*', time: :daily } where '*' is the default and can be
## left out of the hash
default['ftb_server']['auto_restart']['time'] = { minute: '0', hour: '5' }
