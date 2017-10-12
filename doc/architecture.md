# Architecture

### Instances

The server is class based, so you may create multiple independent servers but you may also create
only one server listening on multiple ports/ip addresses.

### Listener

An listener is the base for a server. It will connect an IP/Port combination with a specific
protocol (HTTP/HTTPS) to the server. Give a label (default: `root`) to later access it.

### Labels

Labels are used to identify a specific part of the server. Each listener needs an label, if not
given `root` is used. If you add a plugin you will always add it to the areas with a specific label.

### Plugins
