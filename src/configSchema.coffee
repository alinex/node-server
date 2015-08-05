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
          description: "the host and port to bind to by label"
          type: 'object'
          entries: [
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
              tls:
                title: "HTTPS Server"
                description: "the settings to have listen using SSL"
                type: 'object'
                allowedKeys: true
                keys:
                  pfx:
                    title: "PKCS#12 Certificate"
                    description: "the PKCS#12 certificate, private key and CA
                    certificates to use for SSL"
                    type: 'string'
                  cert:
                    title: "x509 Certificate"
                    description: "the public x509 certificate to use"
                    type: 'string'
                  key:
                    title: "Private Key"
                    description: "the private key to use for SSL"
                    type: 'string'
                  passphrase:
                    title: "Passphrase"
                    description: "the passphrase for the private key or pfx if necessary"
                    type: 'string'
                  ca:
                    title: "Authority Certificate"
                    description: "an authority certificate or array of authority certificates
                    to check the remote host against"
                    type: 'string'
                  ciphers:
                    title: "Ciphers"
                    description: "a string describing the ciphers to use or exclude
                    (http://www.openssl.org/docs/apps/ciphers.html#CIPHER_LIST_FORMAT)"
                    type: 'string'
                  rejectUnauthorized:
                    title: "Reject Unathorized"
                    description: "a flag to check server certificate against the
                    list of supplied CAs"
                    type: 'boolean'
                  secureProtocol:
                    title: "SSL Method"
                    description: "the SSL method to use, e.g. TLSv1_method to force TLS version 1
                    (the possible values depend on your installation of OpenSSL and
                    are defined in the constant SSL_METHODS)"
                    type: 'string'
              load:
                title: "Load Limit"
                description: "the limit after which the server will respond with
                503 code to incoming requests"
                type: 'object'
                allowedKeys: true
                keys:
                  maxHeap:
                    title: "Maximum Heap"
                    description: "the maximum V8 heap size over which incoming
                    requests are rejected"
                    type: 'byte'
                  maxRss:
                    title: "Maximum RSS"
                    description: "the maximum process RSS size over which incoming
                    requests are rejected"
                    type: 'byte'
                  eventLoopDelay:
                    title: "Maximum Event Loop Delay"
                    description: "the maximum event loop delay duration in milliseconds
                    over which incoming requests are rejected"
                    type: 'interval'
                    unit: 'ms'
          ]
