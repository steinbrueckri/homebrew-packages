class Ringo < Formula
  desc "Terminal SIP softphone built on baresip"
  homepage "https://github.com/davidborzek/ringo"
  license "MIT"

  depends_on "baresip"

  on_macos do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.7.2/ringo-aarch64-apple-darwin"
      sha256 "fafeee462da968748a7d934fbe5fa7a50c320f1ff22663cfe70ec4dd28366e92"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.7.2/ringo-x86_64-apple-darwin"
      sha256 "9779df28911d1117779494731d0bdeede96e42770ca5538ceff64ce33ca3ccab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.7.2/ringo-aarch64-unknown-linux-gnu"
      sha256 "2c5d71a82c816aa7fce9d22a4ff66fdc7e9c0f06ad97fbdd03892cf389032425"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.7.2/ringo-x86_64-unknown-linux-gnu"
      sha256 "2031677bdcb105ba3091130fe19d6a921f2235d35a0a7e85246e382c5456a77b"
    end
  end

  def install
    bin.install stable.url.split("/").last => "ringo"
  end

  test do
    system "#{bin}/ringo", "--help"
  end
end
