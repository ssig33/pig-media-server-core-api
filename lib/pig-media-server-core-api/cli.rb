require 'thor'

module PigMediaServerCoreAPI
  class CLI < Thor
    desc 'server [PORT]', 'run server'
    option :bind, :type => :string, :default => '0.0.0.0'
    option :port, :type => :numeric, :default => 8080
    def server(port = nil)
      require 'pig-media-server-core-api/api'
      port ||= options[:port]
      Sinatra::Base.server.delete 'HTTP' # conflict with HTTP.gem
      PigMediaServerCoreAPI::Web.run! :bind => options[:bind], :port => port.to_i
    end
  end
end
