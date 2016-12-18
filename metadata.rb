name 'ftb_server'
maintainer 'Stefan Wendler'
maintainer_email 'stefan@binarysun.de'
license 'apache'
description 'Installs/Configures a Feed the Beast Server on FreeBSD'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/mrmarbury/ftb_server/issues' if respond_to?(:issues_url)
source_url 'https://github.com/mrmarbury/ftb_server' if respond_to?(:source_url)

version '0.8.2'

depends 'poise-archive', '~> 1.3.0'
