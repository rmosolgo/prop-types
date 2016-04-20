require "test_helper"

class GeneratorTest < Minitest::Test
  def generate_prop_types(hash, options={})
    PropTypes::Generator.new(hash, options).to_js
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

  def test_it_uses_keys_for_unnamed_hashes
    example_hash = {
      grandparents: [
        {name: "George", age: 72},
        {name: "Lucille", age: 68},
      ],
      members: [
        {name: "Michael", age: 45},
        {name: "George Michael", age: 17},
      ]
    }

    expected = %|var agenameShape = React.PropTypes.shape({
  age: React.PropTypes.number.isRequired,
  name: React.PropTypes.string.isRequired
})

React.PropTypes.shape({
  grandparents: React.PropTypes.arrayOf(agenameShape.isRequired).isRequired,
  members: React.PropTypes.arrayOf(agenameShape.isRequired).isRequired
}).isRequired|

    assert_equal expected, generate_prop_types(example_hash)
  end

  def test_it_applies_a_function_wrapper_if_requested
    example_hash = {
      grandparents: [
        {name: "George", age: 72},
        {name: "Lucille", age: 68},
      ],
      members: [
        {name: "Michael", age: 45},
        {name: "George Michael", age: 17},
      ]
    }

    expected = %|(function() {
  var agenameShape = React.PropTypes.shape({
    age: React.PropTypes.number.isRequired,
    name: React.PropTypes.string.isRequired
  })

  return React.PropTypes.shape({
    grandparents: React.PropTypes.arrayOf(agenameShape.isRequired).isRequired,
    members: React.PropTypes.arrayOf(agenameShape.isRequired).isRequired
  }).isRequired
})()|

    assert_equal expected, generate_prop_types(example_hash, function_wrapper: true)
  end

  def test_function_wrapper_reindents_single_object
    example_hash = {
     person: {name: "Maeby", x: true},
     person2: {name: "George Michael"}
    }

    expected = %|(function() {
  return React.PropTypes.shape({
    person: React.PropTypes.shape({
      name: React.PropTypes.string.isRequired,
      x: React.PropTypes.bool.isRequired
    }).isRequired,
    person2: React.PropTypes.shape({
      name: React.PropTypes.string.isRequired
    }).isRequired
  }).isRequired
})()|
    assert_equal expected, generate_prop_types(example_hash, function_wrapper: true)
  end
  def test_it_destructures_if_requested
    example_hash = {
      grandparents: [
        {name: "George", age: 72},
        {name: "Lucille", age: 68},
      ],
      members: [
        {name: "Michael", age: 45},
        {name: "George Michael", age: 17},
      ]
    }

    expected = %|var {arrayOf, number, shape, string} = React.PropTypes

var agenameShape = shape({
  age: number.isRequired,
  name: string.isRequired
})

shape({
  grandparents: arrayOf(agenameShape.isRequired).isRequired,
  members: arrayOf(agenameShape.isRequired).isRequired
}).isRequired|

    assert_equal expected, generate_prop_types(example_hash, destructure: true)
  end

  def test_it_adds_semicolons_if_requested
    example_hash = {
      grandparents: [
        {name: "George", age: 72},
        {name: "Lucille", age: 68},
      ],
      members: [
        {name: "Michael", age: 45},
        {name: "George Michael", age: 17},
      ]
    }

    expected = %|var {arrayOf, number, shape, string} = React.PropTypes;

(function() {
  var agenameShape = shape({
    age: number.isRequired,
    name: string.isRequired
  });

  return shape({
    grandparents: arrayOf(agenameShape.isRequired).isRequired,
    members: arrayOf(agenameShape.isRequired).isRequired
  }).isRequired;
})();|

    assert_equal expected, generate_prop_types(example_hash, semicolons: true, function_wrapper: true, destructure: true)
  end
end
