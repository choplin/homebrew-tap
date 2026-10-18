class Yomu < Formula
  desc "A terminal Markdown reader with rich image, table, and math rendering"
  homepage "https://github.com/choplin/yomu"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/choplin/yomu/releases/download/v0.1.0/yomu-aarch64-apple-darwin.tar.xz"
      sha256 "6c55c7885ad01a37fec71f3f1a68c79c2a870b1505f1543cc258dca9295d734c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/choplin/yomu/releases/download/v0.1.0/yomu-x86_64-apple-darwin.tar.xz"
      sha256 "30d70e266bc2f3d23c3c3819ed668dde29e07080d4fbcff10bded356e54edd46"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/choplin/yomu/releases/download/v0.1.0/yomu-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3991f369edb1115a674819bc5b2cbc2480747c8536377570c9fa63eea3159b53"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "yomu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "yomu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "yomu"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
