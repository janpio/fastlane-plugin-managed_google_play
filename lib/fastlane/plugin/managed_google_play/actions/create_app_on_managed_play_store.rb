require 'fastlane/action'
require_relative '../helper/managed_google_play_helper'

module Fastlane
  module Actions
    class CreateAppOnManagedPlayStoreAction < Action
      def self.run(params)
        
        unless params[:json_key] || params[:json_key_data]
          UI.important("To not be asked about this value, you can specify it using 'json_key'")
          params[:json_key] = UI.input("The service account json file used to authenticate with Google: ")
        end

        FastlaneCore::PrintTable.print_values(
          config: params, 
          mask_keys: [:json_key_data], 
          title: "Summary for CreateAppOnManagedPlayStoreAction"
        )
        
        require "google/apis/playcustomapp_v1"

        # Auth Info
        @keyfile = params[:json_key]
        @developer_account = params[:developer_account_id]

        # App Info
        @apk_path = params[:apk]
        @app_title = params[:app_title]
        @language_code = params[:language]

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
          upload_source: @apk_path,
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
          FastlaneCore::ConfigItem.new(
            key: :json_key,
            env_name: "SUPPLY_JSON_KEY", # TODO
            short_option: "-j",
            conflicting_options: [:json_key_data],
            optional: true, # this shouldn't be optional but is until I find out how json_key OR json_key_data can be required
            description: "The path to a file containing service account JSON, used to authenticate with Google",
            code_gen_sensitive: true,
            default_value: CredentialsManager::AppfileConfig.try_fetch_value(:json_key_file),
            default_value_dynamic: true,
            verify_block: proc do |value|
              UI.user_error!("'#{value}' doesn't seem to be a JSON file") unless FastlaneCore::Helper.json_file?(File.expand_path(value))
              UI.user_error!("Could not find service account json file at path '#{File.expand_path(value)}'") unless File.exist?(File.expand_path(value))
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :json_key_data,
            env_name: "SUPPLY_JSON_KEY_DATA", # TODO
            short_option: "-c",
            conflicting_options: [:json_key],
            optional: true,
            description: "The raw service account JSON data used to authenticate with Google",
            code_gen_sensitive: true,
            default_value: CredentialsManager::AppfileConfig.try_fetch_value(:json_key_data_raw),
            default_value_dynamic: true,
            verify_block: proc do |value|
              begin
                JSON.parse(value)
                rescue JSON::ParserError
                UI.user_error!("Could not parse service account json: JSON::ParseError")
              end
            end
          ),
          #developer_account
          FastlaneCore::ConfigItem.new(key: :developer_account_id,
            short_option: "-k",
            env_name: "PRODUCE_ITC_TEAM_ID", # TODO
            description: "The ID of your Google Play Console account. Can be obtained from the URL when you log in (`https://play.google.com/apps/publish/?account=...` or when you 'Obtain private app publishing rights' (https://developers.google.com/android/work/play/custom-app-api/get-started#retrieve_the_developer_account_id)",
            optional: false,
            is_string: false, # as we also allow integers, which we convert to strings anyway
            code_gen_sensitive: true,
            default_value: CredentialsManager::AppfileConfig.try_fetch_value(:developer_account_id),
            default_value_dynamic: true,
            verify_block: proc do |value|
              raise UI.error("No Developer Account ID given, pass using `developer_account_id: 123456789`") if value.to_s.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :apk,
            env_name: "SUPPLY_APK", # TODO
            description: "Path to the APK file to upload",
            short_option: "-b",
            conflicting_options: [:apk_paths, :aab],
            code_gen_sensitive: true,
            default_value: Dir["*.apk"].last || Dir[File.join("app", "build", "outputs", "apk", "app-Release.apk")].last,
            default_value_dynamic: true,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Could not find apk file at path '#{value}'") unless File.exist?(value)
              UI.user_error!("apk file is not an apk") unless value.end_with?('.apk')
            end
          ),
          #title
          FastlaneCore::ConfigItem.new(key: :app_title,
            env_name: "PRODUCE_APP_NAME", # TODO
            short_option: "-q",
            description: "App Title",
            optional: false,
            verify_block: proc do |value|
              raise UI.error("No App Title given, pass using `app_title: 'Title'`") if value.to_s.empty?
            end
          ),
          #language
          FastlaneCore::ConfigItem.new(key: :language,
            short_option: "-m",
            env_name: "PRODUCE_LANGUAGE", # TODO
            description: "Default app language (e.g. 'en_US')",
            default_value: "en_US",
            optional: false,
            verify_block: proc do |language|
              unless AvailableLanguages.all_languages.include?(language)
                UI.user_error!("Please enter one of available languages: #{AvailableLanguages.all_languages}")
              end
            end
          ),
          # copied from https://github.com/fastlane/fastlane/blob/2fec459d6f44a41eac1b086e8c181bd1669f7f5c/supply/lib/supply/options.rb#L193-L199
          FastlaneCore::ConfigItem.new(key: :root_url,
            env_name: "SUPPLY_ROOT_URL", # TODO
            description: "Root URL for the Google Play API. The provided URL will be used for API calls in place of https://www.googleapis.com/", # TODO check if default is true
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("Could not parse URL '#{value}'") unless value =~ URI.regexp
            end
          ),
          # copied from https://github.com/fastlane/fastlane/blob/2fec459d6f44a41eac1b086e8c181bd1669f7f5c/supply/lib/supply/options.rb#L206-L211
          FastlaneCore::ConfigItem.new(key: :timeout,
            env_name: "SUPPLY_TIMEOUT", # TODO
            optional: true,
            description: "Timeout for read, open, and send (in seconds)",
            type: Integer,
            default_value: 300
          )
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
