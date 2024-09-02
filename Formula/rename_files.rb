class RenameFiles < Formula
  desc "CLI tool (& lib); regex search files & optionally rename. Recursive and Test flags available, but intentionally minimal."
  homepage "https://github.com/ethanmsl/rename_files"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.3/rename_files-aarch64-apple-darwin.tar.xz"
      sha256 "a8a9f1862f75ef1d891a8ff32fa9a24c0aa24aa81ef28a4bc4e482adc0fcfecf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.3/rename_files-x86_64-apple-darwin.tar.xz"
      sha256 "4701c3fa7a6d2903991595543e2f8b600dbd5c9217e213e60c49599d4d098fa3"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ethanmsl/rename_files/releases/download/v0.4.3/rename_files-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4bec5cbbc2eb0c5fa09bb412eb8ff0767213dc879496f68ab6423bb6bc99f6d"
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
