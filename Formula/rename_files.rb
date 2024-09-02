class RenameFiles < Formula
  desc "CLI tool (& lib); regex search files & optionally rename. Recursive and Test flags available, but intentionally minimal."
  homepage "https://github.com/ethanmsl/rename_files"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.4/rename_files-aarch64-apple-darwin.tar.xz"
      sha256 "2e159cab52493e6ada7a6e303aea01237b68e7e1d8ad40139d32c51890e666d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.4/rename_files-x86_64-apple-darwin.tar.xz"
      sha256 "7ed91edd1d2f4b4c02d7e954b0fcf3c547eab3778236a17fa7973a7a72a50e88"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.4/rename_files-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e63c180a11ddb0834d56e7502d5e37f10a9748343dbdf83edbeeb441b86ba869"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "rename_files"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rename_files"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rename_files"
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
