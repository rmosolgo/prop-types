module PropTypes
  class Generator
    def initialize(example_props,
        function_wrapper: false,
        destructure:      false,
        semicolons:       false,
        alphabetize:      true,
        dangle_commas:    false,
        required:         true
      )

      @example_props = example_props
      @function_wrapper = function_wrapper
      @destructure = destructure
      @alphabetize = alphabetize

      @dangling_comma = dangle_commas ? "," : ""
      @semicolon = semicolons ?         ";" : ""
      @is_required = required ?         ".isRequired" : ""
    end

    def to_js
      @to_js ||= generate_code(@example_props)
    end

    private

    ANY_PROP_TYPE =     "React.PropTypes.any"
    BOOL_PROP_TYPE =    "React.PropTypes.bool"
    NUMBER_PROP_TYPE =  "React.PropTypes.number"
    STRING_PROP_TYPE =  "React.PropTypes.string"

    def generate_code(props)
      object_cache = PropTypes::ShapeCache.new
      base_shape = generate_prop_type(nil, props, 1, object_cache) + @semicolon

      if @function_wrapper
        base_shape = "return #{base_shape}"
      end

      base_shape = object_cache.apply_shapes(base_shape)

      if @function_wrapper
        base_shape = PropTypes::Indent.reindent_object("\n#{base_shape}", 1)
        base_shape = "(function() {#{base_shape}\n})()#@semicolon"
      end

      if @destructure
        destructure_header = Destructure.create_header(base_shape, @semicolon)
        base_shape = Destructure.strip_globals(base_shape)
        base_shape = "#{destructure_header}\n\n#{base_shape}"
      end

      base_shape
    end

    # Can't do functions
    # Can't tell if required or not
    # Assumes arrays are continued list of same type
    # Thinks that `nil` is `any`
    def generate_prop_type(key_name, props, current_depth, object_cache)
      case props
      when String
        STRING_PROP_TYPE + @is_required
      when NilClass
        ANY_PROP_TYPE
      when Numeric
        NUMBER_PROP_TYPE + @is_required
      when TrueClass, FalseClass
        BOOL_PROP_TYPE + @is_required
      when Array
        # this is wrong - it should do `shape()` if it's not a shape-name
        "React.PropTypes.arrayOf(" + generate_prop_type(nil, props[0], current_depth, object_cache) + ")" + @is_required
      when Hash
        cached_shape = object_cache.cache(props) do
          prop_type = hash_to_prop_type(props, current_depth, object_cache)
          PropTypes::CachedShape.new(nil, prop_type, props, semicolon: @semicolon)
        end
        key_name && cached_shape.offer_name("#{key_name}Shape")
        cached_shape.increment
        cached_shape.id + @is_required
      else
        raise "Can't generate prop for #{props} (#{props.class})"
      end
    end

    def hash_to_prop_type(props, current_depth, object_cache)
      own_indent = PropTypes::Indent.create(current_depth - 1)
      next_indent = PropTypes::Indent.create(current_depth)
      keys = apply_sort(props.keys)

      "React.PropTypes.shape({" +
        keys.map { |key|
          next_indent +
          "#{key}: " +
          generate_prop_type(key, props[key], current_depth + 1, object_cache)
        }.join(",") +
        @dangling_comma +
      own_indent + "})"
    end

    def apply_sort(strings)
      if @alphabetize
        strings.sort
      else
        strings
      end
    end
  end
end
