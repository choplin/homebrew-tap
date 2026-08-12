class Agentlog < Formula
  desc "A local browser for AI coding-agent session history"
  homepage "https://github.com/choplin/agentlog"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/choplin/agentlog/releases/download/v0.1.0/agentlog-aarch64-apple-darwin.tar.xz"
      sha256 "c150dfbd41d29c25921edc32f64a82028d24b2fdeb373ddc18f3af1e9603c757"
    end
    if Hardware::CPU.intel?
      url "https://github.com/choplin/agentlog/releases/download/v0.1.0/agentlog-x86_64-apple-darwin.tar.xz"
      sha256 "3b055e063e5948b11f133ff7b73f632a59a893332e89dfcbb462ce0e21ec7101"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/choplin/agentlog/releases/download/v0.1.0/agentlog-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8f4187ed1d97543526a118af0c00083284baa0746f22bebe5929c0662de91090"
    end
    if Hardware::CPU.intel?
      url "https://github.com/choplin/agentlog/releases/download/v0.1.0/agentlog-x86_64-unknown-linux-musl.tar.xz"
      sha256 "06ba615bbbb9298a939aa065a5157041bf787dacef2fc470d69f44b90b0e7cfe"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "agentlog"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "agentlog"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "agentlog"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "agentlog"
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
