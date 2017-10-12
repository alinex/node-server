# How To

Here I will show how to easily use this server.

### Create Instance

```js
import Server from '../../src/index'

const server = new Server()
```

You include the server and make a new server instance to work with it.


```js
server.listen({
  labels: 'root',
  port: 3000,
  host: 'localhost',
})
```
