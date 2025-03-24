class Pik < Formula
  desc "Interactive Kubernetes pod picker"
  homepage "https://github.com/jacek-kurlit/pik"
  url "https://github.com/jacek-kurlit/pik/releases/download/0.18.1/pik-0.18.1-aarch64-apple-darwin.tar.gz"
  sha256 "b781568358aac9f57a3a2efe6014e8e3d8ad5931cfa2074152c1d32fdc903de7"
  version "0.18.1"
  license "MIT"

  def install
    bin.install "pik"
  end

  test do
    system "#{bin}/pik", "--help"
  end
end
