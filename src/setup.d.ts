import * as Hapi from "hapi"
// export { Hapi.ServerConnectionInfo as IInfo }

export interface IListener {
  label?: string | string[],
  host?: string,
  port?: number,
  tls?: {
    readonly key: string,
    readonly cert: string,
  },
//  routes?: {
//    cors?: boolean,
//  }
}

export interface IRoute {
  label?: string[] | string,
  vhost?: string,
  method: "GET" | "POST" | "PUT" | "PATCH" | "DELETE" | "OPTIONS",
  path: string,
  handler: (request: any, reply: any) => void,
  options?: {},
  description?: string
}

export interface IPlugin {
  // where to connect
  label?: string[] | string,
  vhost?: string,
  prefix?: string,
  // what to do
  plugin: {
    ( app: Hapi.Server,
      options: any,
      next: () => void,
    ): void,
    attributes?: {
      name: string,
    },
  }
//  export interface PluginFunction<OptionsPassedToPlugin> {
//      (server: Server, options: OptionsPassedToPlugin, next: (err?: Error) => void): void;
//      /**
//       * Note attributes is NOT optional but this type is easier to use.
//       */
//      attributes?: PluginAttributes;
//  }

  options?: Hapi.PluginRegistrationOptions,
}

export interface IConfig {
  listen?: IListener | IListener[]
  route?: IRoute[]
}
