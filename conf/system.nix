self_: with self_;
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  configurationRevision = self_.rev or self_.dirtyRev or null;
  stateVersion = 6;

  defaults = {
    dock.autohide = true;

    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  primaryUser = "hays";
  startup.chime = false;
}