require "test_helper"

class GeneratorTest < Minitest::Test
  def generate_prop_types(hash)
    PropTypes::Generator.new(hash).to_js
  end

  def test_it_generates_alphabetized_types_from_scalars
    example_hash = {
      numberVal: 1,
      boolVal: true,
      stringVal: "str",
      nullVal: nil,
    }

    expected = %|React.PropTypes.shape({
  boolVal: React.PropTypes.bool.isRequired,
  nullVal: React.PropTypes.any,
  numberVal: React.PropTypes.number.isRequired,
  stringVal: React.PropTypes.string.isRequired
}).isRequired|


    assert_equal expected, generate_prop_types(example_hash)
  end

  def test_it_dedups_reused_shapes
    example_hash = {
      name: "Hall and Oates",
      hall: {name: "Daryl Hall"},
      oates: {name: "Johnny Oates"},
      band: [{name: "Daryl Hall"}, {name: "Johnny Oates"}]
    }

    expected = %|var hallShape = React.PropTypes.shape({
  name: React.PropTypes.string.isRequired
})

React.PropTypes.shape({
  band: React.PropTypes.arrayOf(hallShape.isRequired).isRequired,
  hall: hallShape.isRequired,
  name: React.PropTypes.string.isRequired,
  oates: hallShape.isRequired
}).isRequired|

    assert_equal expected, generate_prop_types(example_hash)
  end


  def test_it_leaves_single_use_shapes_in_place
    example_hash = {
      company1: {name: "Bluth Company"},
      company2: {name: "Michael B. Company"},
      different_company: {name: "Illusions by GOB", puppet: "Franklin"},
    }

    expected = %|var company1Shape = React.PropTypes.shape({
  name: React.PropTypes.string.isRequired
})

React.PropTypes.shape({
  company1: company1Shape.isRequired,
  company2: company1Shape.isRequired,
  different_company: React.PropTypes.shape({
    name: React.PropTypes.string.isRequired,
    puppet: React.PropTypes.string.isRequired
  }).isRequired
}).isRequired|

    assert_equal expected, generate_prop_types(example_hash)
  end
end
