require 'fastlane/action'
require_relative '../helper/managed_google_play_helper'

module Fastlane
  module Actions
    class ManagedGooglePlayAction < Action
      def self.run(params)
        
        require "google/apis/playcustomapp_v1"

        # Auth Info
        @keyfile = ENV['KEYFILE_PATH']
        @developer_account = ENV['DEVELOPER_ACCOUNT']

        # App Info
        @apk_path = "artifacts/app-release.apk"
        @app_title = "App title!"
        @language_code = "en_US"

        # login
        scope = 'https://www.googleapis.com/auth/androidpublisher'
        credentials = JSON.parse(File.open(@keyfile, 'rb').read)
        auth_client = Signet::OAuth2::Client.new(
            :token_credential_uri => 'https://oauth2.googleapis.com/token',
            :audience => 'https://oauth2.googleapis.com/token',
            :scope => scope,
            :issuer => credentials['client_id'],
            :signing_key => OpenSSL::PKey::RSA.new(credentials['private_key'], nil),
        )
        UI.message('auth_client: ' + auth_client.inspect)
        auth_client.fetch_access_token!

        # service
        play_custom_apps = Google::Apis::PlaycustomappV1::PlaycustomappService.new
        play_custom_apps.authorization = auth_client
        UI.message('play_custom_apps with auth: ' + play_custom_apps.inspect)

        # app
        custom_app = Google::Apis::PlaycustomappV1::CustomApp.new title: @app_title, language_code: @language_code
        UI.message('custom_app: ' + custom_app.inspect)

        # create app
        returned = play_custom_apps.create_account_custom_app(
          @developer_account,
          custom_app,
          upload_source: nil #,
          #upload_source: @apk_path,
        ) do |created_app, error|
          unless error.nil?
            puts "Error: #{error}"
            UI.error(error.inspect)
          else
            puts "Success: #{created_app}."
            UI.success(created_app)
          end
        end
        UI.message('returned: ' + returned.inspect)

      end

      def self.description
        "Create Managed Google Play Apps"
      end

      def self.authors
        ["Jan Piotrowski"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "none yet"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "MANAGED_GOOGLE_PLAY_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
