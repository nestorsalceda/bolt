require 'sinatra/base'
require 'sinatra/assetpack'
require 'haml'

module Bolt
  class Application < Sinatra::Base
    register Sinatra::AssetPack

    get '/' do
      haml :index, layout: :layout
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
