# frozen_string_literal: true

require "omniauth/strategies/tiktok"
require "spec_helper"

def deep_stringify_keys(hash)
  JSON.parse(JSON.dump(hash))
end

describe OmniAuth::Strategies::Tiktok, type: :strategy do
  subject do
    described_class.new(app, "appid", "secret", {}).tap do |strategy|
      allow(strategy).to receive(:request) do
        request
      end
    end
  end

  let(:request) { double("Request", params: {}, cookies: {}, env: {}) }
  let(:app)     { ->(_env) { [200, {}, ["Hello."]] } }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe "#info, #uid, #extra" do
    let(:client) do
      OAuth2::Client.new("abc", "def") do |builder|
        builder.request :url_encoded
        builder.adapter :test do |stub|
          stub.get("/open_api/v1.3/user/info/") { [200, { "content-type" => "application/json" }, response_hash.to_json] }
        end
      end
    end

    let(:response_hash) do
      {
        message: "OK",
        code: 0,
        data: {
          create_time: 1_617_793_706,
          display_name: "cameron",
          id: 5_555_555_555_555_555_555,
          email: "cameron@example.com"
        },
        request_id: "202104090941490102360412201D2AE6AE"
      }
    end

    let(:access_token) { OAuth2::AccessToken.from_hash(client, {}) }

    before { allow(subject).to receive(:access_token).and_return(access_token) }

    it "#uid" do
      expect(subject.uid).to eq("202104090941490102360412201D2AE6AE")
    end

    it "#info" do
      expect(subject.info).to eq({ display_name: "cameron", email: "cameron@example.com" })
    end

    it "#extra" do
      expect(subject.extra).to eq("raw_info" => deep_stringify_keys(response_hash))
    end
  end
end
