# frozen_string_literal: true

require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class Tiktok < OmniAuth::Strategies::OAuth2
      option :name, "tiktok"

      option :client_options, site: "https://ads.tiktok.com",
                              authorize_url: "/marketing_api/auth",
                              token_url: "/open_api/v1.2/oauth2/access_token/",
                              user_info_url: "/open_api/v1.1/user/info/"

      uid { raw_info.dig("data", "id") }

      info do
        prune!(
          display_name: raw_info.dig("data", "display_name"),
          email: raw_info.dig("data", "email")
        )
      end

      extra do
        { "raw_info" => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(options.dig("client_options", "user_info_url")).parsed
      end

      def authorize_params
        super.merge({ app_id: options.client_id })
      end

      def token_params
        super.merge({ app_id: options.client_id, secret: options.client_secret })
      end

      private

      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)

          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end
    end
  end
end
