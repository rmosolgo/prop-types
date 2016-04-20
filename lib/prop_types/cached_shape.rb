module PropTypes
  class CachedShape
    attr_reader :name, :prop_type, :uses_count, :id
    def initialize(name, prop_type, example_hash, semicolon:)
      @id = "shapeId#{self.class.next_id}"
      if name.nil?
        @name = example_hash.keys.sort.join("") + "Shape"
        @unnamed = true
      else
        @name = name
        @unnamed = false
      end

      @semicolon = semicolon
      @prop_type = prop_type
      @uses_count = 0
    end

    def offer_name(name)
      if @unnamed
        @name = name
        @unnamed = false
      end
    end

    def increment
      @uses_count += 1
    end

    def to_var
      dedented_prop_type = PropTypes::Indent.reindent_object(prop_type, 0)
      "var #{name} = #{dedented_prop_type}#@semicolon"
    end

    class << self
      def next_id
        @id ||= 0
        @id += 1
      end
    end
  end
end
