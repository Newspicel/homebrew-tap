class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "soapysdr"

  on_macos do
    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.3/sdrmm-0.8.3-aarch64-apple-darwin.tar.gz"
      sha256 "da963efb9cb5621bd1ffec4d64c098065b49051aa7051f2bd2109dfe24a5181e"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.3/sdrmm-0.8.3-x86_64-apple-darwin.tar.gz"
      sha256 "ec15b84fcd29d48032b89628e44c2a52a21d1e8ad5015dc496b8cd1209ac5c78"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.3/sdrmm-0.8.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d7854d8d1d6abcc5a1f7f53e95a71c45b3f78c93f531624c815fe14736fb8c70"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.3/sdrmm-0.8.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "490c72853344984f559026e3c749a8ab6e7c84fcdc6c3957b935eedb1844588a"
    end
  end

  def install
    bin.install "sdrmm"
    doc.install "LICENSE", "README.md", "THIRD_PARTY_NOTICES.md"

    if OS.mac?
      MachO::Tools.add_rpath(bin/"sdrmm", formula_opt_lib("soapysdr").to_s)
      system "codesign", "--sign", "-", "--force", bin/"sdrmm"
    else
      system formula_opt_bin("patchelf")/"patchelf",
             "--set-rpath", formula_opt_lib("soapysdr"), bin/"sdrmm"
    end
  end

  def caveats
    <<~EOS
      RTL-SDR, HackRF, RTL-TCP and SpyServer receivers are built in. Other hardware is
      reached through SoapySDR modules, which install separately:
        brew install soapyremote

      Start the server on port 8080 with `sdrmm`, or in the background with
      `brew services start sdrmm`. `sdrmm --doctor` reports what this build can see.
    EOS
  end

  service do
    run [opt_bin/"sdrmm"]
    log_path var/"log/sdrmm.log"
    error_log_path var/"log/sdrmm.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sdrmm --version")
    assert_match "SoapySDR runtime", shell_output("#{bin}/sdrmm --doctor")
  end
end
