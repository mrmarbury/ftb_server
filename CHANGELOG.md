# CHANGELOG

# 0.1.0

 - initial Version
 
# 0.8.0
 
 - Installs/updates a FTB Server
 - Documentation 
 - No tests yet
 
# 0.8.1

 - Fixed typo in settings-local.sh 
 
# 0.8.2

 - Added explicit restart to rc-script
 - notifies restart on settings-local.sh changes
 
# 0.9.0

 - auto_restart implemented
 - Service can now be renamed
 - defaults-tests done
 - smaller fixes
 - settings-local.sh notify removed for now
 
# 0.9.1

 - set path and changed default shell to csh for auto_restart. That fixes the bug where FTB won't restart
   when triggered via cronjob

# 0.9.2

 - trying more Xmx
 - some stubs for monit and mod_dynmap
 - some refinements and dependency updates

# 0.10.0

 - basic dynmap installation
 - some refinements

# 0.10.1

 - refinements on documentation
 - some tests
 - Since monit recipe is not working yet, it returns after printing an error
 
# 0.10.2

 - dynmap symlink was not created
 
# 0.10.3

 - basic dynmap configuration with webpage_title set to pack version and name

# 0.10.4

 - typo in flm Confirm Java option
