export default interface IListener {
  labels?: string[] | string,
  host?: string,
  port?: number,
  tls?: {
    readonly key: string,
    readonly cert: string,
  },
  routes?: {
    cors?: boolean,
  }
}
