export interface IServerConfig {
  labels?: string,
  host?: string,
  port?: number,
  tls?: {
    readonly key: string,
    readonly cert: string,
  },
}
