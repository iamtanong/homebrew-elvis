class Elvis < Formula
  desc "A CLI tool that lets you preview file-system commands"
  homepage "https://github.com/iamtanong/elvis"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-aarch64-apple-darwin.tar.xz"
      sha256 "8ffa431c8c9ea9ff48567432394f8a6b655d95289504373ba2f293bb3ef2b827"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-x86_64-apple-darwin.tar.xz"
      sha256 "3478b6d4241df8bdd509e97cdc5c1b5ed864dd308e21dfdb84f3c22bfd2e4984"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0efa559dcbbbd926b90de52fa2106cd5cb4aa2aa8081db485456ce87b87eaf64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iamtanong/elvis/releases/download/v0.1.0/elvis-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "97d1158dfe368528b8b9f14bd0cfcad910acb0a98ec58141ea272eedad62ac8c"
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
