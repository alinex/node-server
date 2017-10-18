import * as Hapi from "hapi"

export default interface IPlugin {
  // where to connect
  labels: string[] | string,
  vhost?: number,
  prefix?: number,
  // ehat to do
  plugin: Hapi.PluginFunction<object>,
  options?: Hapi.PluginRegistrationOptions,
}
