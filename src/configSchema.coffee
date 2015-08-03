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
                    title: ""
                    description: "the Certificate, Private key and CA certificates to use for SSL. Default null."
                    type: 'string'
                  key:
                    title: ""
                    description: "the Private key to use for SSL. Default null."
                    type: 'string'
                  passphrase:
                    title: ""
                    description: "the A string of passphrase for the private key or pfx. Default null."
                    type: 'string'
                  cert:
                    title: ""
                    description: "the Public x509 certificate to use. Default null."
                    type: 'string'
                  ca:
                    title: ""
                    description: "the An authority certificate or array of authority certificates to check the remote host against.§
                    type: 'string'
                  ciphers:
                    title: ""
                    description: "the A string describing the ciphers to use or exclude. Consult http://www.openssl.org/docs/apps/ciphers.html#CIPHER_LIST_FORMAT for details on the format.""
                    type: 'string'
                  rejectUnauthorized:
                    title: ""
                    description: "the If true, the server certificate is verified against the list of supplied CAs. An 'error' event is emitted if verification fails. Verification happens at the connection level, before the HTTP request is sent. Default true."
                    type: 'boolean'
                  secureProtocol:
                    title: ""
                    description: "the The SSL method to use, e.g. TLSv1_method to force TLS version 1. The possible values depend on your installation of OpenSSL and are defined in the constant SSL_METHODS."
                    type: 'string'
          ]
