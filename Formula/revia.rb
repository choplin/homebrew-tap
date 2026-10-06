class Revia < Formula
  desc "An interactive terminal UI for reviewing Git diffs"
  homepage "https://github.com/choplin/revia"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/choplin/revia/releases/download/v0.1.0/revia-aarch64-apple-darwin.tar.xz"
      sha256 "c70631cf13d438d502a0e40a18a48c30d51803c24933c029f067114e7702d4e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/choplin/revia/releases/download/v0.1.0/revia-x86_64-apple-darwin.tar.xz"
      sha256 "62332989ca2500a89c159a366530c8de4bce9f45c958bfc4236bd6bd910c925b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/choplin/revia/releases/download/v0.1.0/revia-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2a95b920d7e4fad604fdd1ad9d14fafc12451820508e5e8f068de2e575ab9725"
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
      bin.install "revia"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "revia"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "revia"
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
