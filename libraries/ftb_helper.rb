require 'json'

module Ftb
  module Helper

    def ftb_is_upgradeable(new_version, pack_dir)

      version_file = File.join pack_dir, 'version.json'

      unless File.exists? version_file
        return true
      end

      json_hash = JSON.parse(File.read(version_file))

      if json_hash['packVersion'] == new_version
        Chef::Log.warn "Pack versions are equal - Marking as not eligible for update!"
        false
      else
        Chef::Log.warn "Current pack version:'#{json_hash['packVersion']}' differs from installable pack version" \
                       " #{new_version} - Marking as eligible for update!"
        true
      end
    end
  end
end
