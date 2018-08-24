require 'fastlane/action'
require_relative '../helper/managed_google_play_helper'

module Fastlane
  module Actions
    class ManagedGooglePlayAction < Action
      def self.run(params)
        UI.message("The managed_google_play plugin is working!")
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
