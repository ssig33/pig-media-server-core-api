require 'sinatra/base'
require 'pit'
require 'pig-media-server-core-api/model/pig'

module PigMediaServerCoreAPI
  class Web < Sinatra::Base
    def page
      params[:page].to_i < 1 ? 1 : params[:page].to_i
    end

    def size
      params[:size] ? params[:size].to_i : 50
    end

    def list_to_json list
      list.map{|x|
        hash = x.to_hash
        hash['custom_links'] = partial :_custom_links, locals: {record: x}
        hash['metadata'] = !!x.metadata and x.metadata != ''
        hash['srt'] = !!x.metadata and x.metadata != ''
        hash
      }.to_json
    end

    def config
      Pit.get("Pig Media Server")
    end

    helpers do
      def partial(template, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options.merge!(:layout => false)
        if collection = options.delete(:collection) then
          collection.inject([]) do |buffer, member|
            buffer << haml(template, options.merge(:layout => false, :locals => {template => member}))
          end.join("\n")
        else
          haml(template, options)
        end
      end
    end

    get '/api/r/latest' do
      content_type :json
      list_to_json(Groonga['Files'].select.paginate([key: 'mtime', order: 'descending'], size: size, page: page).map{|x| Pig.new(x)})
    end

    get '/api/r/custom' do
      content_type :json
      c = config['custom_list'][params[:name]]
      if c and File.exists? c
        list_to_json(Pig.find JSON.parse(open(c).read))
      else
        [].to_json
      end
    end

    get '/api/r/recommend' do
      content_type :json
      list = []
      begin
        keys = open("#{config['user_data_path']}/recommend/#{params[:name]}").read.split("\n")
        list = Pig.find(keys)
      rescue
      end

      list_to_json(list)
    end

    get '/api/r/search' do
      content_type :json
      list_to_json(Pig.search params.merge(page: page))
    end
  end
end
