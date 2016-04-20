module PropTypes
  module Indent
    INDENT = "  "
    def self.create(depth)
      "\n#{INDENT * depth}"
    end

    def self.reindent_object(code, new_depth)
      new_indent = create(new_depth)
      original_indent = code.scan(/(\n *)\}/).last[0]
      code
        .gsub(original_indent, new_indent)
        .gsub(/^ +$/, "") # Remove any whitespace-only lines
    end
  end
end
