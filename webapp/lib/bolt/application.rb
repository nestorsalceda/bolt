require 'sinatra/base'
require 'faye/websocket'
require 'sinatra/assetpack'
require 'haml'
require 'json'

module Bolt
  class Application < Sinatra::Base
    register Sinatra::AssetPack

    def initialize(app = nil)
      super(app)
      @factory = Factory.new

      @lights_handler = @factory.lights_handler
      @temperature_retriever = @factory.temperature_retriever
      @message_hub = @factory.message_hub
      @temperature_repository = @factory.temperature_repository
      start_background_tasks
    end

    get '/' do
      unless Faye::WebSocket.websocket?(request.env)
        haml :index, layout: :layout, locals: {
          :enabled =>  @lights_handler.enabled?,
          :temperature => @temperature_retriever.temperature
        }
      else
        ws = Faye::WebSocket.new(request.env)

        ws.on :open do
          @message_hub.add_subscriber(ws)
        end

        ws.on :close do
          @message_hub.remove_subscriber(ws)
        end

        ws.rack_response
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
        '/js/raphael-min.js',
        '/js/morris.js',
      ]

      css :application, [
        '/css/bootstrap.css',
        '/css/bootstrap-theme.css',
        '/css/bootstrap-switch.css',
        '/css/morris.css',
        '/css/application.css'
      ]

      js_compression :jsmin
      css_compression :sass
    end

    private

    def start_background_tasks
      @scheduled_temperature_registerer = @factory.scheduled_temperature_registerer
      @scheduled_temperature_registerer.start

      @scheduled_temperature_notifier = @factory.scheduled_temperature_notifier
      @scheduled_temperature_notifier.start

      @scheduled_temperatures_for_today_notifier = @factory.scheduled_temperatures_for_today_notifier
      @scheduled_temperatures_for_today_notifier.start
    end


  end
end
