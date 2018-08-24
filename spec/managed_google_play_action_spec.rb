describe Fastlane::Actions::ManagedGooglePlayAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The managed_google_play plugin is working!")

      Fastlane::Actions::ManagedGooglePlayAction.run(nil)
    end
  end
end
