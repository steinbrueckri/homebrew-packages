class InputSourceSelector < Formula
  desc "Input Source Selector for macOS"
  homepage "https://github.com/ershov/InputSourceSelector"
  # NOTE:
  url "https://github.com/ershov/InputSourceSelector/archive/99e1579a88be115d80a41c80afb197d8c9be29d4.zip"
  sha256 "65bb9f16eaffcdf1da0e93d2c076778bdba0b6c33c9e282807dbd20e3dcda9df"
  license "MIT"

  uses_from_macos "swift" => [:build]

  def install
    swiftc = "/Library/Developer/CommandLineTools/usr/bin/swiftc"
    if !File.exist?(swiftc)
      odie "Xcode Command Line Tools not found, please install them using 'xcode-select --install'"
    end
    system "swiftc", "InputSourceSelector.swift", "-o", "InputSourceSelector"
    bin.install "InputSourceSelector"
  end

  test do
    system "#{bin}/InputSourceSelector", "--help"
  end
end
