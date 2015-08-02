# Check definitions
# =================================================
# This contains check definitions for the
# [alinex-validator](http://alinex.github.io/node-validator).

module.exports =
  title: "Server"
  description: "the configuration of servers (connected by client)"
  type: 'object'
  allowedKeys: true
  keys:
    http:
      title: "Webserver"
      description: "the configuration for the webserver"
      type: 'object'
      allowedKeys: true
      keys:
        listen:
          title: "Listen"
          description: "the host and port to bind to"
          type: 'array'
          entries:
            type: 'object'
            allowedKeys: true
            mandatoryKeys: ['port']
            keys:
              host:
                title: "Host or IP"
                description: "the hostname or ip address to bind to"
                type: 'or'
                or: [
                  type: 'ipaddr'
                ,
                  type: 'hostname'
                ]
              port:
                title: "Port"
                description: "the port to listen on"
                type: 'port'
                default: 23174
        trustProxy:
          title: "Enable proxy forwarding"
          description: "the flag that enables that the X-Forwarded headers will be trusted"
          type: 'boolean'
          default: false
