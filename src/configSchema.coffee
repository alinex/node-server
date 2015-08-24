# Check definitions
# =================================================
# This contains check definitions for the
# [alinex-validator](http://alinex.github.io/node-validator).

# Connection Settings
# -------------------------------------------------

listener =
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
        ,
          type: 'file'
          filetype: 'socket'
          exists: true
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


# Binding of Spaces and Plugins
# -------------------------------------------------
bind =
  title: "Binding"
  description: "the connection, domain and context to only bind to"
  type: 'object'
  allowedKeys: true
  keys:
    listener:
      title: "Listener"
      description: "the name of the defined listener"
      type: 'array'
      toArray: true
      entries:
        type: 'string'
        values: '<<<listener>>>'
    domain:
      title: "Domain Name"
      description: "the hostname to bind to"
      type: 'array'
      toArray: true
      entries:
        type: 'hostname'
    context:
      title: "Context"
      description: "the context path to bind to"
      type: 'array'
      toArray: true
      entries:
        type: 'string'
        startsWith: '/'
        minLength: 1

# Log Settings
# -------------------------------------------------
log =
  title: "Log Settigs"
  description: "the host and port to bind to by label"
  type: 'array'
  toArray: true
  entries:
    title: "Log Transport"
    description: "the configuration of a log transporter"
    type: 'object'
    allowedKeys: true
    mandatoryKeys: ['data']
    keys:
      data:
        title: "Data Type"
        description: "the type of data to log"
        type: 'string'
        list: [
          'error', 'event'
          'common', 'commonvhost', 'combined', 'referrer'
          'extended'
          'object'
        ]
      bind: bind
      file:
        title: "File Logger"
        description: "the setup of an file logger"
        type: 'object'
        allowedKeys: true
        keys:
          filename:
            title: "Filename"
            description: "the filename within the log directory"
            type: 'file'
          datePattern:
            title: "Rotation Pattern"
            description: "the date pattern to be used for rotating files"
            type: 'string'
            minLength: 1
          maxSize:
            title: "max. Size"
            description: "the maximum file size before file rotation"
            type: 'byte'
            min: 1
          maxFiles:
            title: "max. Files"
            description: "the maximum number of files (older ones will be deleted on rotation)"
            type: 'integer'
            min: 1
          compress:
            title: "Compress"
            description: "a flag indicating rotated files should be compressed"
            type: 'boolean'
      http:
        title: "HTTP Webservice"
        description: "a service to send log entries to"
        type: 'object'
        allowedKeys: true
        keys:
          host:
            title: "Hostname or IP"
            description: "the hostname or ip address to send to"
            type: 'or'
            or: [
              type: 'ipaddr'
            ,
              type: 'hostname'
            ]
          port:
            title: "Port"
            description: "the port of the service to use"
            type: 'port'
          path:
            title: "Request URI Path"
            description: "the uri path to send request to"
            type: 'string'
            startsWith: '/'
            minLength: 2
          auth:
            title: "Authentication"
            description: "the basic authentication settings"
            type: 'object'
            mandatoryKeys: true
            keys:
              username:
                title: "Username"
                description: "the username to use for basic authentication"
                type: 'string'
              password:
                title: "Password"
                description: "the password used for basic authentication"
                type: 'string'
          secure:
            title: "Secure Connection"
            description: "a flag indicating to user https protocol"
            type: 'boolean'
      mail:
        title: "Mail Logger"
        description: "the configuration for a mail logger"
        type: 'object'
        allowedKeys: true
        keys:
          to:
            title: "To"
            description: "the email address to send email to"
            type: 'string'
          from:
            title: "From"
            description: "the origin email address used as sender"
            type: 'string'
          host:
            title: "SMTP Host"
            description: "the SMTO hostname if needed"
            type: 'or'
            or: [
              type: 'ipaddr'
            ,
              type: 'hostname'
            ]
          port:
            title: "SMTP Port"
            description: "the port of the SMTP host is listening"
            type: 'port'
          secure:
            title: "Secure Protocol"
            description: "a flag indicating to use secure connections"
            type: 'boolean'
          auth:
            title: "Authentication"
            description: "the smtp authentication settings"
            type: 'object'
            mandatoryKeys: true
            keys:
              username:
                title: "Username"
                description: "the username to use for smtp authentication"
                type: 'string'
              password:
                title: "Password"
                description: "the password used for smtp authentication"
                type: 'string'

# Authentication
# -------------------------------------------------
auth =
  type: 'object'
  keys:
    bind: bind

# Application routes
# -------------------------------------------------
app =
  type: 'object'

# Spaces
# -------------------------------------------------
space =
  title: "Spaces"
  description: "the server spaces which are an abstraction of the listener"
  type: 'object'
  entries: [
    title: "Space"
    description: "the server space which is an abstraction of the listener"
    type: 'object'
    mandatoryKeys: ['bind']
    allowedKeys: true
    keys:
      bind: bind
      theme:
        type: 'string'
        default: 'default'
      log: log
      auth: auth
      app: app
  ]

# Server Settings
# -------------------------------------------------

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
        listener: listener
        log: log
        auth: auth
        app: app
        space: space
