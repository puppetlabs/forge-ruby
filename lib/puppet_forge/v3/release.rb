require 'puppet_forge/v3/base'
require 'puppet_forge/v3/module'

module PuppetForge
  module V3

    # Models a specific release version of a Puppet Module on the Forge.
    class Release < Base

      # Returns a fully qualified URL for downloading this release from the Forge.
      #
      # @return [String] fully qualified download URL for release
      def download_url
        if URI.parse(file_uri).host.nil?
          PuppetForge.host + file_uri
        else
          file_uri
        end
      end

      # Downloads the Release tarball to the specified file path.
      #
      # @todo Stream the tarball data to disk.
      # @param file [String] the file to create
      # @return [void]
      def download(file)
        self.class.get_raw(download_url)[:response].on_complete do |env|
          File.open(file, 'wb') { |file| file.write(env[:body]) }
        end
        nil
      end
    end
  end
end
