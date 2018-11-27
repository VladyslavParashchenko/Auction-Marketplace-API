# frozen_string_literal: true

include Swagger::Docs::ImpotentMethods
class Swagger::Docs::Config
  def self.transform_path(path, _api_version)
    "apidocs/#{path}"
  end
end
Swagger::Docs::Config.base_api_controllers = [ApplicationController]

Swagger::Docs::Config.register_apis(
  "1.0" => {
    api_extension_type: :json,
    api_file_path:      "public/apidocs",
    clean_directory:    true,
    attributes:         {
      info: {
        "title"       => "Auction MarketPlace API",
        "description" => "API for auction"
      }
    }
  }
)
