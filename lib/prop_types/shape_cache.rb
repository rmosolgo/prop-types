module PropTypes
  class ShapeCache
    def initialize
      @storage = {}
    end

    def cache(props) # &block
      cache_key = props.keys.sort.join(",")
      @storage[cache_key] ||= yield
    end

    def apply_shapes(base_shape)
      shapes = @storage.values.reverse
      shapes.each do |cached_shape|
        if cached_shape.uses_count == 1
          base_shape = base_shape.sub(cached_shape.id, cached_shape.prop_type)
        else
          base_shape = base_shape.gsub(cached_shape.id, cached_shape.name)
          base_shape = "#{cached_shape.to_var}\n\n#{base_shape}"
        end
      end
      base_shape
    end
  end
end
