require 'puppet_forge/v3/base'
require 'puppet_forge/v3/module'

require 'digest'

module PuppetForge
  module V3

    # Models a specific release version of a Puppet Module on the Forge.
    class Release < Base
      lazy :module, 'Module'

      # Returns a fully qualified URL for downloading this release from the Forge.
      #
      # @return [String] fully qualified download URL for release
      def download_url
        if URI.parse(file_uri).host.nil?
          URI.join(PuppetForge.host, file_uri[1..-1]).to_s
        else
          file_uri
        end
      end

      # Downloads the Release tarball to the specified file path.
      #
      # @param path [Pathname]
      # @return [void]
      def download(path)
        resp = self.class.conn.get(download_url)
        path.open('wb') { |fh| fh.write(resp.body) }
      rescue Faraday::ResourceNotFound => e
        raise PuppetForge::ReleaseNotFound, (_("The module release %{release_slug} does not exist on %{url}.") % {release_slug: slug, url: self.class.conn.url_prefix}), e.backtrace
      rescue Faraday::ClientError => e
        if e.response && e.response[:status] == 403
          raise PuppetForge::ReleaseForbidden.from_response(e.response)
        else
          raise e
        end
      end

      # Verify that a downloaded module matches the best available checksum in the metadata for this release,
      # validates SHA-256 checksum if available, otherwise validates MD5 checksum
      #
      # @param path [Pathname]
      # @return [void]
      def verify(path, allow_md5 = true)
        checksum =
          if self.respond_to?(:file_sha256) && !self.file_sha256.nil? && !self.file_sha256.size.zero?
            {
              type: "SHA-256",
              expected: self.file_sha256,
              actual: Digest::SHA256.file(path).hexdigest,
            }
          elsif allow_md5
            {
              type: "MD5",
              expected: self.file_md5,
              actual: Digest::MD5.file(path).hexdigest,
            }
          else
            raise PuppetForge::Error.new("Cannot verify module release: SHA-256 checksum is not available in API response and fallback to MD5 has been forbidden.")
          end

        return if checksum[:expected] == checksum[:actual]

        raise ChecksumMismatch.new("Unable to validate #{checksum[:type]} checksum for #{path}, download may be corrupt!")
      end

      class ChecksumMismatch < StandardError
      end
    end
  end
end
