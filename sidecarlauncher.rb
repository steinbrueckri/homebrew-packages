class Sidecarlauncher < Formula
  desc "A commandline tool to connect to a Sidecar capable device."
  homepage "https://github.com/Ocasio-J/SidecarLauncher"
  url "https://github.com/Ocasio-J/SidecarLauncher/releases/download/1.2/SidecarLauncher.zip"
  sha256 "fc3df81639f400aaff9b44ba20650cf56ef2f73a033b927bbe378cb3c73b9764"
  version "1.2"

  def install
    bin.install "SidecarLauncher"
  end
end
