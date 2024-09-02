class RenameFiles < Formula
  desc "CLI tool (& lib); regex search files & optionally rename. Recursive and Test flags available, but intentionally minimal."
  homepage "https://github.com/ethanmsl/rename_files"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.2/rename_files-aarch64-apple-darwin.tar.xz"
      sha256 "c7ad6d500b6ed81e8412edd9531572fdbd1fa16dab9d3557fdedbc057c63950b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.2/rename_files-x86_64-apple-darwin.tar.xz"
      sha256 "3aa05d37ae196998be3d177ffcf33358d253f4a5dc036535f570d754e51c9223"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.2/rename_files-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f89a9b5e509536282ec7347f958352e87b10a2797b0a142134755d6baaff7a40"
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
