require "dotenv"
require "active_support/all"
require "action_view"

#-----------------------------------------------------------------------------
# Directories
#-----------------------------------------------------------------------------

set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

#-----------------------------------------------------------------------------
# Plugins
#-----------------------------------------------------------------------------

activate :livereload
activate :dotenv
activate :directory_indexes

activate :imageoptim do |config|
  config.manifest = true
  config.image_extensions = %w(.png .jpg .gif .svg)
  config.pngout = false
  config.svgo = false
end

activate :autoprefixer do |config|
  config.browsers = ["last 2 version", "safari 5", "ie 8", "ie 9", "opera 12.1", "ios 6", "android 4"]
end

activate :s3_sync do |sync|
  sync.bucket = ENV.fetch("AWS_BUCKET_NAME")
  sync.region = ENV.fetch("AWS_REGION")
  sync.aws_access_key_id = ENV.fetch("AWS_ACCESS_KEY_ID")
  sync.aws_secret_access_key = ENV.fetch("AWS_SECRET_ACCESS_KEY")
  sync.delete = true
  sync.path_style = true
  sync.prefer_gzip = true
  sync.after_build = false
end

#-----------------------------------------------------------------------------
# Misc Config
#-----------------------------------------------------------------------------

after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end

# Build-specific configuration
configure :build do
  activate :gzip
  activate :asset_hash
  activate :minify_css
  activate :minify_javascript
  activate :minify_html

  ignore "images/icons/*"
  ignore "images/icons-2x/*"
  ignore "stylesheets/app/*"
  ignore "javascripts/app/*"
end

#-----------------------------------------------------------------------------
# Helpers
#-----------------------------------------------------------------------------

helpers do
  # def helper_method; end
end
