# Check definitions
# =================================================
# This contains different check definitions for the
# [alinex-validator](http://alinex.github.io/node-validator).

server =
  title: "Webserver configuration"
  description: "the configuration for the webserver"
  type: 'object'
  allowedKeys: true
  entries:
    port:
      title: "Http Port"
      description: "the port to listen"
      type: 'integer'
      default: 23174
