class RenameFiles < Formula
  desc "CLI tool (& lib); regex search files & optionally rename. Recursive and Test flags available, but intentionally minimal."
  homepage "https://github.com/ethanmsl/rename_files"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.0/rename_files-aarch64-apple-darwin.tar.xz"
      sha256 "6cceb6022dcd0e5171882538e5ab508bb75ae54540303c8fc5217343589ca57f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.0/rename_files-x86_64-apple-darwin.tar.xz"
      sha256 "5961b01d97db4fe2c7c2a778018d68f57a40740bddbcb82e8dc276be5ace4fca"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.0/rename_files-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc8b557621d331b09fc89c695c27eb537b988861e224b0ec1cac8c0a102d0348"
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
