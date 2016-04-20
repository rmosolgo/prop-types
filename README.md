# PropTypes

Generate PropTypes from JSON ([try it online](http://rmosolgo.github.io/prop-types)):

![image](https://cloud.githubusercontent.com/assets/2231765/14688299/f31173f2-070f-11e6-94cd-0f864f8ec528.png)

With some limitations:

- Can't take functions
- Assumes `null` is `any`
- Assumes any value `isRequired`
- Only checks first value of array (assumes all other values are the same type)
- Assumes that objects with the same keys are meant to be the same shape

### Development

```
cd web && python -m SimpleHTTPServer
```

```
rake deploy
```
