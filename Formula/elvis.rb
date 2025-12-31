class Elvis < Formula
  desc "A CLI tool that lets you preview file-system commands"
  homepage "https://github.com/iamtanong/elvis"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-aarch64-apple-darwin.tar.xz"
      sha256 "2910b0fe474694d121d63768cd3cb13e80ad179b08ecd5175083d5d579fb25c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-x86_64-apple-darwin.tar.xz"
      sha256 "200e62901f33e0dc439bad5a0b208247665c5853fbe94da3d8bf3705706dd87b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fdb9d017609a42864de86272dc1e2426fcfc5a7f1543904ce84c0c7df93a7d84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9576f0fc5f061da8ebee5f1ef839aa2a2c984792e0a73a2ec812813e4cc1f063"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "elvis" if OS.mac? && Hardware::CPU.arm?
    bin.install "elvis" if OS.mac? && Hardware::CPU.intel?
    bin.install "elvis" if OS.linux? && Hardware::CPU.arm?
    bin.install "elvis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
