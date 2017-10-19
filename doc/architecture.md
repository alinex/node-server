# Architecture

## Setup


### Instances

The server is class based, so you may create multiple independent servers but you
may also create only one server listening on multiple ports/ip addresses.

### Listener

An listener is the base for a server. It will connect an IP/Port combination with a
specific protocol (HTTP/HTTPS) to the server. The server may listen to multiple
IP/Ports.
With a label (default: `root`) it should be easy accessible later.

    server = new Server(config)
    server.listen(config)

### Routes

To define what to do if a specific path is called routes have to be defined. They
bind a given function to the specified path.

    server.route()

### Plugins

Plugins encapsulate code and path and can be added similar like routes to serve
below specific prefix paths.

    server.plugin()


## Control

After the server is completely defined it can be used.

    server.start()
    server.stop()
