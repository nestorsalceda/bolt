require 'sinatra/base'
require 'sinatra-websocket'
require 'sinatra/assetpack'
require 'haml'

module Bolt
  class Application < Sinatra::Base
    register Sinatra::AssetPack

    def initialize(app = nil)
      super(app)
      @lights_service = Factory::create_light_service
      @sockets = []
    end

    get '/' do
      if !request.websocket?
        haml :index, layout: :layout, locals: { :enabled =>  @lights_service.enabled? }
      else
        request.websocket do |ws|
          ws.onopen do
            @sockets << ws
          end
          ws.onclose do
            @sockets.delete(ws)
          end
        end
      end
    end

    post '/rgb' do
      if params[:color].nil?
        @lights_service.rgb(255, 255, 255)
      else
        red = params[:color][1,2].hex
        green = params[:color][3,2].hex
        blue = params[:color][5,2].hex
        @lights_service.rgb(red, green, blue)
      end
      broadcast('enabled')
    end

    post '/disable' do
      @lights_service.disable
      broadcast('disabled')
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

    private

    def broadcast(message)
      EM.next_tick { @sockets.each { |socket| socket.send(message) } }
    end
  end
end
