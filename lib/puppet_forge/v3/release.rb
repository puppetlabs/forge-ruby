require 'puppet_forge/v3/base'
require 'puppet_forge/v3/module'

module PuppetForge
  module V3

    # Models a specific release version of a Puppet Module on the Forge.
    class Release < Base

      def initialize(json_response)
        @module_info = json_response['module']

        super
      end

      def module
        @module ||= Module.find(@module_info['slug'])
        @module
      end

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
      # @param path [Pathname]
      # @return [void]
      def download(path)
        resp = self.class.conn.get(file_url)
        path.open('wb') { |fh| fh.write(resp.body) }
      rescue Faraday::ResourceNotFound => e
        raise PuppetForge::ReleaseNotFound, "The module release #{slug} does not exist on #{conn.url_prefix}.", e.backtrace
      end

      # Verify that a downloaded module matches the checksum in the metadata for this release.
      #
      # @param path [Pathname]
      # @return [void]
      def verify(path)
        expected_md5 = file_md5
        file_md5     = Digest::MD5.file(path).hexdigest
        if expected_md5 != file_md5
          raise ChecksumMismatch.new("Expected #{path} checksum to be #{expected_md5}, got #{file_md5}")
        end
      end

      private

      def file_url
        "/v3/files/#{slug}.tar.gz"
      end

      def resource_url
        "/v3/releases/#{slug}"
      end

      class ChecksumMismatch < StandardError
      end

    end
  end
end
