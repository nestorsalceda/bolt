require 'sinatra/base'
require 'sinatra/assetpack'
require 'haml'

module Bolt
  class Application < Sinatra::Base
    register Sinatra::AssetPack

    def initialize(app = nil)
      super(app)
      @lights_service = LightService.new
    end

    get '/' do
      haml :index, layout: :layout, locals: { :enabled => @lights_service.enabled? }
    end

    post '/enable' do
      @lights_service.enable
    end

    post '/disable' do
      @lights_service.disable
    end

    assets do
      serve '/js', :from => 'static/js'
      serve '/css', :from => 'static/css'

      js :modernizr, [
        '/js/vendor/modernizr.js',
      ]

      js :application, [
        '/js/vendor/jquery.js',
        '/js/foundation/foundation.js',
      ]

      css :application, [
        '/css/normalize.css',
        '/css/foundation.css',
        '/css/application.css'
      ]

      js_compression :jsmin
      css_compression :sass
    end
  end
end
