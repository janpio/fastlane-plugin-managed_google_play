require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class ManagedGooglePlayHelper
      # class methods that you define here become available in your action
      # as `Helper::ManagedGooglePlayHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the managed_google_play plugin helper!")
      end
    end
  end
end
