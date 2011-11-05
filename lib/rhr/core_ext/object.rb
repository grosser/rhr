class Object
  def memoize(*names)
    names.each do |name|
      unmemoized = "__unmemoized_#{name}"
      class_eval %{
        alias   :#{unmemoized} :#{name}
        private :#{unmemoized}
        def #{name}(*args)
          cache = (@#{unmemoized} ||= {})
          if cache.has_key?(args)
            cache[args]
          else
            cache[args] = send(:#{unmemoized}, *args).freeze
          end
        end
      }
    end
  end unless defined?(memoize)

  # Memoize class methods
  def cmemoize(*method_names)
    (class << self; self; end).class_eval do
      memoize(*method_names)
    end
  end unless defined?(cmemoize)
end
