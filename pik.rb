class Pik < Formula
  desc "Interactive Kubernetes pod picker"
  homepage "https://github.com/jacek-kurlit/pik"
  url "https://github.com/jacek-kurlit/pik/releases/download/1.0.0/pik-1.0.0-aarch64-apple-darwin.tar.gz"
  sha256 "4c7d38cc7810d2234fe309aea83520a85c9b5c880f503bcc8fc4023b61ce4486"
  license "MIT"

  def install
    bin.install "pik"
  end

  test do
    system "#{bin}/pik", "--help"
  end
end
