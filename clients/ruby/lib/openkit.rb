module OpenKit

  class Config
    #the host can also be changes to support your own server
    @host = 'api.gameeso.com'  # default
    class << self
      attr_accessor :app_key, :secret_key
      attr_accessor :host
      attr_accessor :skip_https
    end
  end
end

require_relative 'openkit/request'
require_relative "openkit/version"

