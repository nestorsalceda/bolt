require 'sinatra/base'
require 'sinatra-websocket'
require 'sinatra/assetpack'
require 'haml'

module Bolt
  class Application < Sinatra::Base
    register Sinatra::AssetPack

    def initialize(app = nil)
      super(app)
      factory = Factory.new

      @lights_handler = factory.create_lights_handler
      @temperature_retriever = factory.create_temperature_retriever

      @message_hub = MessageHub.new
      @scheduled_temperature_retriever = ScheduledTemperatureRetriever.new(@temperature_retriever, @message_hub)
      @scheduled_temperature_retriever.schedule_and_notify
    end

    get '/' do
      if !request.websocket?
        haml :index, layout: :layout, locals: {
          :enabled =>  @lights_handler.enabled?,
          :temperature => @temperature_retriever.temperature
        }
      else
        request.websocket do |ws|
          ws.onopen do
            @message_hub.add_subscriber(ws)
          end
          ws.onclose do
            @message_hub.remove_subscriber(ws)
          end
        end
      end
    end

    post '/rgb' do
      if params[:color].nil?
        @lights_handler.rgb(255, 255, 255)
      else
        red = params[:color][1,2].hex
        green = params[:color][3,2].hex
        blue = params[:color][5,2].hex
        @lights_handler.rgb(red, green, blue)
      end
      @message_hub.broadcast({ :type => :lights, :enabled => true })
    end

    post '/disable' do
      @lights_handler.disable
      @message_hub.broadcast({ :type => :lights, :enabled => false })
    end

    assets do
      serve '/js', :from => 'static/js'
      serve '/css', :from => 'static/css'
      serve '/fonts', :from => 'static/fonts'

      js :modernizr, [
        '/js/vendor/modernizr.js',
      ]

      js :application, [
        '/js/vendor/jquery.js',
        '/js/bootstrap.js',
        '/js/bootstrap-switch.js',
      ]

      css :application, [
        '/css/bootstrap.css',
        '/css/bootstrap-theme.css',
        '/css/bootstrap-switch.css',
        '/css/application.css'
      ]

      js_compression :jsmin
      css_compression :sass
    end
  end
end
