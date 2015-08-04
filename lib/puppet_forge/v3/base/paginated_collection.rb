module PuppetForge
  module V3
    class Base

      # Enables navigation of the Forge API's paginated datasets.
      class PaginatedCollection < Array

        # Default pagination limit for API request
        LIMIT = 20

        # @api private
        # @param klass [PuppetForge::V3::Base] the class to page over
        # @param data [Array] the current data page
        # @param metadata [Hash<(:limit, :total, :offset)>] page metadata
        # @param errors [Object] errors for the page request
        def initialize(klass, data = [], metadata = {:total => 0, :offset => 0, :limit => LIMIT}, errors = nil)
          super()
          @metadata = metadata
          @errors = errors
          @klass = klass

          data.each do |item|
            self << @klass.new(item)
          end
        end

        # For backwards compatibility, all returns the current object.
        def all
          self
        end

        # An enumerator that iterates over the entire collection, independent
        # of API pagination. This will potentially result in several API
        # requests.
        #
        # @return [Enumerator] an iterator for the entire collection
        def unpaginated
          page = @klass.get_collection(@metadata[:first])
          Enumerator.new do |emitter|
            loop do
              page.each { |x| emitter << x }
              break unless page = page.next
            end
          end
        end

        # @!method total
        #   @return [Integer] the size of the unpaginated dataset
        # @!method limit
        #   @return [Integer] the maximum size of any page in this dataset
        # @!method offset
        #   @return [Integer] the offset for the current page
        [ :total, :limit, :offset ].each do |info|
          define_method(info) { @metadata[info] }
        end

        [ :next, :previous ].each do |link|
          # @!method next
          #   Returns the next page if a next page exists.
          #   @return [PaginatedCollection, nil] the next page
          # @!method previous
          #   Returns the previous page if a previous page exists.
          #   @return [PaginatedCollection, nil] the previous page
          define_method(link) do
            return unless path = @metadata[link]
            @klass.get_collection(path)
          end

          # @!method next_url
          #   Returns the url of the next page if a next page exists.
          #   @return [String, nil] the next page's url
          # @!method previous_url
          #   Returns the url of the previous page if a previous page exists.
          #   @return [String, nil] the previous page's url
          define_method("#{link}_url") do
            @metadata[link]
          end
        end
      end
    end
  end
end
