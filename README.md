# PropTypes

Generate PropTypes from JSON ([try it online](http://rmosolgo.github.io/prop-types)):

![image](https://cloud.githubusercontent.com/assets/2231765/14822766/e0f5eef4-0b9d-11e6-89bd-e50f9eb85363.png)


With some limitations:

- Can't take functions
- Assumes `null` is `any`
- Assumes any value `isRequired`
- Only checks first value of array (assumes all other values are the same type)
- Assumes that objects with the same keys are meant to be the same shape

### Development

- Run the tests:

  ```
  rake test
  ```

- Rebuild the Javascript:

  ```
  rake compile_js
  ```

- Start a preview HTTP server:

  ```
  cd web && python -m SimpleHTTPServer
  ```

- Push to Github pages:

  ```
  rake deploy
  ```
