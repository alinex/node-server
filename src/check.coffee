# Check definitions
# =================================================
# This contains check definitions for the
# [alinex-validator](http://alinex.github.io/node-validator).

server =
  title: "Webserver configuration"
  description: "the configuration for the webserver"
  type: 'object'
  allowedKeys: true
  entries:
    port:
      title: "Http Port"
      description: "the port to listen on"
      type: 'integer'
      default: 23174
    proxy:
      title: "Enable proxy forwarding"
      description: "the flag that enables that the X-Forwarded headers will be trusted"
      type: 'boolean'
      default: false
