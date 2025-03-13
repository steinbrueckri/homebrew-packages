class Themr < Formula
  desc "A program to set a global theme by replacing strings in config files"
  homepage "https://github.com/cultab/themr/"
  license "MIT"
  head do
    url "https://github.com/cultab/themr.git", branch: "master"
  end

  depends_on "go" => :build
  depends_on "make" => :build

  def install
    system "make", "build"
    bin.install "themr"
  end

  test do
    system "#{bin}/themr", "--version"
  end
end
