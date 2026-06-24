class Ringo < Formula
  desc "Terminal SIP softphone built on baresip"
  homepage "https://github.com/davidborzek/ringo"
  license "MIT"

  depends_on "baresip"

  on_macos do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.0/ringo-aarch64-apple-darwin"
      sha256 "98c487dfa6e794bf9558bc025a5fca7daf4f7e9f63f409f5b34a2b449db0f2cb"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.0/ringo-x86_64-apple-darwin"
      sha256 "edf304e245e1fbc7fc85c4d911a0364ef887012862ba544e0ed8b780d8052cb9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.0/ringo-aarch64-unknown-linux-gnu"
      sha256 "6e22042d81336ebf2f654a56c07b3743746c32548f69ef28d84bc6f1d3cd03db"
    end
    on_intel do
      url "https://github.com/davidborzek/ringo/releases/download/v0.10.0/ringo-x86_64-unknown-linux-gnu"
      sha256 "ef3e1f0385f93b145fa28dbf677aeaf6028094fad16004fc96c97d411a78ab31"
    end
  end

  def install
    bin.install stable.url.split("/").last => "ringo"
  end

  test do
    system "#{bin}/ringo", "--help"
  end
end
