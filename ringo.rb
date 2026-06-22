class Ringo < Formula
  desc "Terminal SIP softphone built on baresip"
  homepage "https://github.com/davidborzek/ringo"
  license "MIT"

  depends_on "baresip"

  on_macos do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.9.0/ringo-aarch64-apple-darwin"
      sha256 "2e952ebb1f9dca4954076a7dffad5d63ecdbb8f3f45122045dd88c87b4a7655a"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.9.0/ringo-x86_64-apple-darwin"
      sha256 "d044a110a6dbe3c1229590feb8737311a03cc4dac4f7023092970a6b78ee2acc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.9.0/ringo-aarch64-unknown-linux-gnu"
      sha256 "e91396f5942d5c4a456e2517a605e7ef59af62f4a9c385d659907b97facb80f5"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.9.0/ringo-x86_64-unknown-linux-gnu"
      sha256 "72de04ba758d22992ba3128309150578887d4b55bcdc7d641230867a47256f92"
    end
  end

  def install
    bin.install stable.url.split("/").last => "ringo"
  end

  test do
    system "#{bin}/ringo", "--help"
  end
end
