module PropTypes
  module Destructure
    def self.create_header(base_shape, semicolon)
      required_fns = base_shape.scan(/React\.PropTypes\.([A-Za-z]+)/).flatten.uniq.sort
      "var {#{required_fns.join(", ")}} = React.PropTypes#{semicolon}"
    end

    def self.strip_globals(base_shape)
      base_shape.gsub("React.PropTypes.", "")
    end
  end
end
