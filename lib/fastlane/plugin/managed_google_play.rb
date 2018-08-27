require 'fastlane/plugin/managed_google_play/version'

module Fastlane
  module ManagedGooglePlay
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::ManagedGooglePlay.all_classes.each do |current|
  require current
end

# https://stackoverflow.com/a/1274703/252627
class AvailableLanguages
  def self.all_languages
    %w[
      af
      am
      ar
      az_AZ
      be
      bg
      bn_BD
      ca
      cs_CZ
      da_DK
      de_DE
      el_GR
      en_AU
      en_CA
      en_GB
      en_IN
      en_SG
      en_US
      en_ZA
      es_419
      es_ES
      es_US
      et
      eu_ES
      fa
      fi_FI
      fil
      fr_CA
      fr_FR
      gl_ES
      hi_IN
      hr
      hu_HU
      hy_AM
      id
      is_IS
      it_IT
      iw_IL
      ja_JP
      ka_GE
      km_KH
      kn_IN
      ko_KR
      ky_KG
      lo_LA
      lt
      lv
      mk_MK
      ml_IN
      mn_MN
      mr_IN
      ms
      ms_MY
      my_MM
      ne_NP
      nl_NL
      no_NO
      pl_PL
      pt_BR
      pt_PT
      rm
      ro
      ru_RU
      si_LK
      sk
      sl
      sr
      sv_SE
      sw
      ta_IN
      te_IN
      th
      tr_TR
      uk
      vi
      zh_CN
      zh_HK
      zh_TW
      zu
    ]
  end
end
