# PropTypes

Generate PropTypes from JSON ([try it online](http://rmosolgo.github.io/prop-types)):

![image](https://cloud.githubusercontent.com/assets/2231765/14684035/e78b2fb4-06fb-11e6-8840-9de5aabbe369.png)

With some limitations:

- Can't take functions
- Assumes `null` is `any`
- Assumes any value `isRequired`
- Only checks first value of array (assumes all other values are the same type)
