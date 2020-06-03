require_relative 'config'

# provides a space for emergent properties based on the Config gem's natural abilities
{
  full_hostname_with_protocol: (OmnibotConfig.use_tls ? "https://" : "http://") + OmnibotConfig.hostname
}.each_pair do |k, v|
  OmnibotConfig[k] = v
end