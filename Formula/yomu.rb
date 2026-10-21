class Yomu < Formula
  desc "A terminal Markdown reader with rich image, table, and math rendering"
  homepage "https://github.com/choplin/yomu"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/choplin/yomu/releases/download/v0.2.0/yomu-aarch64-apple-darwin.tar.xz"
      sha256 "0275b534fc98b346b93fb78ab4f654fc257eb15b8d185866aba39d232b8ba192"
    end
    if Hardware::CPU.intel?
      url "https://github.com/choplin/yomu/releases/download/v0.2.0/yomu-x86_64-apple-darwin.tar.xz"
      sha256 "edad79f9f363159b459bd21247134a4d614bc8fbedd871c19337fe16e49aa092"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/choplin/yomu/releases/download/v0.2.0/yomu-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b06c441ed916d2a1a3d2a8a65b60519952a70af241e8e3e1e117ff11cbb45458"
    end
    if Hardware::CPU.intel?
      url "https://github.com/choplin/yomu/releases/download/v0.2.0/yomu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68e92018fcc5427f04a6412011b3a0879172d238f127cd2cf67c4475b3249247"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "yomu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "yomu"
    end
    if OS.linux? && Hardware::CPU.arm?
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
