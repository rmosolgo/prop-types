module PropTypes
  module Indent
    INDENT = "  "
    def self.create(depth)
      "\n#{INDENT * depth}"
    end

    def self.reindent_object(code, new_depth)
      new_indent = create(new_depth)
      original_indent = code.match(/(\n *)\}/)[1]
      code.gsub(original_indent, new_indent)
    end
  end
end
