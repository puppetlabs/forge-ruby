module PuppetForge

  # This module provides convenience accessors for related resources. Related
  # classes will include {LazyAccessors}, allowing them to transparently fetch
  # fetch more complete representations from the API.
  #
  # @see LazyAccessors
  module LazyRelations

    # Mask mistaken `include` calls by transparently extending this class.
    # @private
    def self.included(base)
      base.extend(self)
    end

    def parent
      if self.is_a? Class
        class_name = self.name
      else
        class_name = self.class.name
      end

      # Get the name of the version module
      version = class_name.split("::")[-2]

      if version.nil?
        raise RuntimeError, _("Unable to determine the parent PuppetForge version module")
      end

      PuppetForge.const_get(version)
    end
    # @!macro [attach] lazy
    #   @!method $1
    #     Returns a lazily-loaded $1 proxy. To eagerly load this $1, call
    #     #fetch.
    #     @return a proxy for the related $1
    #
    # Declares a new lazily loaded property.
    #
    # This is particularly useful since our data hashes tend to contain at
    # least a partial representation of the related object. This mechanism
    # provides a proxy object which will avoid making HTTP requests until
    # it is asked for a property it does not contain, at which point it
    # will fetch the related object from the API and look up the property
    # from there.
    #
    # @param name [Symbol] the name of the lazy attribute
    # @param class_name [#to_s] the lazy relation's class name
    def lazy(name, class_name = name)
      klass = (class_name.is_a?(Class) ? class_name : nil)
      class_name = "#{class_name}"

      define_method(name) do
        @_lazy ||= {}

        @_lazy[name] ||= begin

          klass ||= parent.const_get(class_name)

          klass.send(:include, PuppetForge::LazyAccessors)
          fetch unless has_attribute?(name)
          value = attributes[name]
          klass.new(value) if value
        end
      end
    end

    # @!macro [attach] lazy_collection
    #   @!method $1
    #     Returns a lazily-loaded proxy for a collection of $1. To eagerly
    #     load any one of these $1, call #fetch.
    #     @return [Array<$2>] a proxy for the related collection of $1
    #
    # Declares a new lazily loaded collection.
    #
    # This behaves like {#lazy}, with the exception that the underlying
    # attribute is an array of property hashes, representing several
    # distinct models. In this case, we return an array of proxy objects,
    # one for each property hash.
    #
    # It's also worth pointing out that this is not a paginated collection.
    # Since the array of property hashes we're wrapping is itself
    # unpaginated and complete (if shallow), wrapping it in a paginated
    # collection doesn't provide any semantic value.
    #
    # @see LazyRelations
    # @param name [Symbol] the name of the lazy collection attribute
    # @param class_name [#to_s] the lazy relation's class name
    def lazy_collection(name, class_name = name)
      klass = (class_name.is_a?(Class) ? class_name : nil)
      class_name = "#{class_name}"

      define_method(name) do
        @_lazy ||= {}

        @_lazy[name] ||= begin
          klass ||= parent.const_get(class_name)
          klass.send(:include, PuppetForge::LazyAccessors)
          fetch unless has_attribute?(name)
          (attribute(name) || []).map { |x| klass.new(x) }
        end
      end
    end
  end
end
