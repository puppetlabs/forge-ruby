module PuppetForge

  # When dealing with a remote service, it's reasonably common to receive only
  # a partial representation of the underlying object, with additional data
  # available upon request. PuppetForge, by default, provides a convenient interface
  # for accessing whatever local data is available, but lacks good support for
  # fleshing out partial representations. In order to build a seamless
  # interface for both local and remote attriibutes, this module replaces the
  # default behavior with an "updatable" interface.
  module LazyAccessors

    # Callback for module inclusion.
    #
    # On each lazy class we'll store a reference to a Module, which will act as
    # the container for the attribute methods.
    #
    # @param base [Class] the Class this module was included into
    # @return [void]
    def self.included(base)
      base.singleton_class.class_eval do
        attr_accessor :_accessor_container
      end
    end

    # Provide class name for object
    #
    def class_name
      self.class.name.split("::").last.downcase
    end

    # Override the default #inspect behavior.
    #
    # The original behavior actually invokes each attribute accessor, which can
    # be somewhat problematic when the accessors have been overridden. This
    # implementation simply reports the contents of the attributes hash.
    def inspect
      attrs = attributes.map do |x, y|
        [ x, y ].join('=')
      end
      "#<#{self.class}(#{uri}) #{attrs.join(' ')}>"
    end

    # Override the default #method_misssing behavior.
    #
    # When we receive a {#method_missing} call, one of three things is true:
    # - the caller is looking up a piece of local data without an accessor
    # - the caller is looking up a piece of remote data
    # - the method doesn't actually exist
    #
    # To solve the remote case, we begin by ensuring our attribute list is
    # up-to-date with a call to {#fetch}, create a new {AccessorContainer} if
    # necessary, and add any missing accessors to the container. We can then
    # dispatch the method call to the newly created accessor.
    #
    # The local case is almost identical, except that we can skip updating the
    # model's attributes.
    #
    # If, after our work, we haven't seen the requested method name, we can
    # surmise that it doesn't actually exist, and pass the call along to
    # upstream handlers.
    def method_missing(name, *args, &blk)
      fetch unless has_attribute?(name.to_s[/\w+/])

      klass = self.class
      mod = (klass._accessor_container ||= AccessorContainer.new(klass))
      mod.add_attributes(attributes.keys)

      if (meth = mod.instance_method(name) rescue nil)
        return meth.bind(self).call(*args)
      else
        return super(name, *args, &blk)
      end
    end

    # Updates model data from the API. This method will short-circuit if this
    # model has already been fetched from the remote server, to avoid duplicate
    # requests.
    #
    # @return [self]
    def fetch
      return self if @_fetch

      klass = self.class

      response = klass.request("#{self.class_name}s/#{self.slug}")
      if @_fetch = response.success?
        self.send(:initialize, response.body)
      end

      return self
    end

    # A Module subclass for attribute accessors.
    class AccessorContainer < Module

      # Creating a new instance of this class will automatically include itself
      # into the provided class.
      #
      # @param base [Class] the class this container belongs to
      def initialize(base)
        base.send(:include, self)
      end

      # Adds attribute accessors, predicates, and mutators for the named keys.
      # Since these methods will also be instantly available on all instances
      # of the parent class, each of these methods will also conservatively
      # {LazyAccessors#fetch} any missing data.
      #
      # @param keys [Array<#to_s>] the list of attributes to create
      # @return [void]
      def add_attributes(keys)
        keys.each do |key|
          next if methods.include?(name = key)

          define_method("#{name}") do
            fetch unless has_attribute?(name)
            attribute(name)
          end

          define_method("#{name}?") do
            fetch unless has_attribute?(name)
            has_attribute?(name)
          end

          define_method("#{name}=") do |value|
            fetch unless has_attribute?(name)
            attributes[name] = value
          end
        end
      end
    end
  end
end
