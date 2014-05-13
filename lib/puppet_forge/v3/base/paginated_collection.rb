module PuppetForge
  module V3
    class Base

      # A subclass of Her::Collection that enables navigation of the Forge API's
      # paginated datasets.
      class PaginatedCollection < Her::Collection

        # In addition to the standard Her::Collection arguments, this
        # constructor requires a reference to the paginated class. This enables
        # the collection to load related pages.
        #
        # @api private
        # @param klass [Her::Model] the class to page over
        # @param data [Array] the current data page
        # @param metadata [Hash<(:limit, :total, :offset)>] page metadata
        # @param errors [Object] errors for the page request
        def initialize(klass, data, metadata, errors)
          super(data, metadata, errors)
          @klass = klass
        end

        # An enumerator that iterates over the entire collection, independent
        # of API pagination. This will potentially result in several API
        # requests.
        #
        # @return [Enumerator] an iterator for the entire collection
        def unpaginated
          page = @klass.get_collection(metadata[:first])
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
          define_method(info) { metadata[info] }
        end

        [ :next, :previous ].each do |link|
          # @!method next
          #   Returns the next page if a next page exists.
          #   @return [PaginatedCollection, nil] the next page
          # @!method previous
          #   Returns the previous page if a previous page exists.
          #   @return [PaginatedCollection, nil] the previous page
          define_method(link) do
            return unless path = metadata[link]
            @klass.get_collection(path)
          end

          # @!method next_url
          #   Returns the url of the next page if a next page exists.
          #   @return [String, nil] the next page's url
          # @!method previous_url
          #   Returns the url of the previous page if a previous page exists.
          #   @return [String, nil] the previous page's url
          define_method("#{link}_url") do
            metadata[link]
          end
        end
      end
    end
  end
end
