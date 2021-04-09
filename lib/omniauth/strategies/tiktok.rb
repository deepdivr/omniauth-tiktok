# frozen_string_literal: true

require "omniauth/strategies/oauth2"
# require 'multi_json'

module OmniAuth
  module Strategies
    class Tiktok < OmniAuth::Strategies::OAuth2
      option :name, "tiktok"

      option :client_options, site: "https://ads.tiktok.com",
                              authorize_url: "/marketing_api/auth",
                              token_url: "/open_api/v1.2/oauth2/access_token/"

      uid { raw_info }

      info do
        prune!(
          {
            # fields
          }
        )
      end

      extra do
        { "raw_info" => raw_info }
      end

      def raw_info
        # TODO: find out what goes in get(...)
        @raw_info ||= access_token.get.parsed
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
