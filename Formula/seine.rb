class Seine < Formula
  desc "Fast streaming entropy scanner"
  homepage "https://github.com/cboone/seine"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cboone/seine/releases/download/v0.1.0/seine-0.1.0-darwin-amd64.tar.gz"
      sha256 "SHA256_FOR_DARWIN_AMD64"
    end

    on_arm do
      url "https://github.com/cboone/seine/releases/download/v0.1.0/seine-0.1.0-darwin-arm64.tar.gz"
      sha256 "SHA256_FOR_DARWIN_ARM64"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cboone/seine/releases/download/v0.1.0/seine-0.1.0-linux-amd64.tar.gz"
      sha256 "SHA256_FOR_LINUX_AMD64"
    end

    on_arm do
      url "https://github.com/cboone/seine/releases/download/v0.1.0/seine-0.1.0-linux-arm64.tar.gz"
      sha256 "SHA256_FOR_LINUX_ARM64"
    end
  end

  def install
    bin.install "seine"
  end

  test do
    system bin/"seine"
  end
end
