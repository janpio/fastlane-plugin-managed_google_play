# managed_google_play plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-managed_google_play)

This [_fastlane_](https://github.com/fastlane/fastlane) plugin enables you to create Android apps on Managed Google Play.

## Installation

Add this plugin to your project by running:

```bash
fastlane add_plugin managed_google_play
```

## About managed_google_play

The plugin `fastlane-plugin_managed_google_play` offers two actions to first enable custom apps for a user account (needed once) and then create such apps. Here is how to use it:

0. If you haven't done so before, start by following the first two steps of Googles ["Get started with custom app publishing"](https://developers.google.com/android/work/play/custom-app-api/get-started) -> ["Preliminary setup"](https://developers.google.com/android/work/play/custom-app-api/get-started#preliminary_setup) instructions: "[Enable the Google Play Custom App Publishing API](https://developers.google.com/android/work/play/custom-app-api/get-started#enable_the_google_play_custom_app_publishing_api)" and "[Create a service account](https://developers.google.com/android/work/play/custom-app-api/get-started#create_a_service_account)". You need the "service account's private key file" to continue.

1. **Enable account to create and publish custom apps**

   Manually run the `get_managed_play_store_publishing_rights` action on the command line in your project:

   ```shell
   fastlane run get_managed_play_store_publishing_rights
   ```

   It will ask for the `json_key` which you answer by pasting the full path of the private key file. The command will output a URL to visit. After logging in you are redirected to a page that outputs your "Developer Account ID" - take note of that, you will need it shortly.

   Note: If your account is already enabled to create custom apps, you can of course skip this step. It only has to executed once for your account to be able to upload custom apps.

2. **Create custom app on Managed Play Store**

   Now you can run the `create_app_on_managed_play_store` action.

   ```shell
   fastlane run create_app_on_managed_play_store
   ```

   This action will ask for the following parameters:

   - `json_key` = Same file as before
   - `developer_account_id` = Use the one you received in the previous step
   - `app_title` = Your app's title
   - `language` = Primary language in BCP 47 format, e.g. `en_US`
   - `apk` = Path of your `.apk` file

   Of course you can also create a lane using the action (if you will do it more than once for example), that could look like this:

   ```ruby
   app_title = 'Your app title'
   language = 'en_US'
   apk = '/files/app-release.apk'
   create_app_on_managed_play_store(
     json_key: ENV['JSON_KEY_FILE'],
     developer_account_id: ENV['DEVELOPER_ACCOUNT_ID'],
     app_title: app_title,
     language: language,
     apk: apk
   )
   ```

   When the action is finished your app is created in the Google Play Console.

## Actions

### `get_managed_play_store_publishing_rights`

TODO document parameters

### `create_app_on_managed_play_store`

TODO document parameters

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
