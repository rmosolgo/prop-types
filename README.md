# PropTypes

Generate PropTypes from JSON ([try it online](http://rmosolgo.github.io/prop-types)):

![image](https://cloud.githubusercontent.com/assets/2231765/14684472/165b9e30-06fe-11e6-85e1-29ec533b4e43.png)

With some limitations:

- Can't take functions
- Assumes `null` is `any`
- Assumes any value `isRequired`
- Only checks first value of array (assumes all other values are the same type)


### Development

```
cd web && python -m SimpleHTTPServer
```

```
rake deploy
```
