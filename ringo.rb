class Ringo < Formula
  desc "Terminal SIP softphone built on baresip"
  homepage "https://github.com/davidborzek/ringo"
  license "MIT"

  depends_on "baresip"

  on_macos do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.1/ringo-aarch64-apple-darwin"
      sha256 "762c2064624382554a04d090b07439370b547a30e3e5f5a387264e0141f91524"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.1/ringo-x86_64-apple-darwin"
      sha256 "e6c15ac9227f590afd49b1859eaa67182b4a1fb1829b31975852e7cec13d737b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.1/ringo-aarch64-unknown-linux-gnu"
      sha256 "c40df68bacef5001c57a927ebea364608d801345db18069fced562cb5c141601"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.1/ringo-x86_64-unknown-linux-gnu"
      sha256 "860fb10e4efe131f27eda3ec8655137304a2efb22b44a7111eaea94d13d2a7a8"
    end
  end

  def install
    bin.install stable.url.split("/").last => "ringo"
  end

  test do
    system "#{bin}/ringo", "--help"
  end
end
