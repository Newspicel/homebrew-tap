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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.6.0/sdrmm-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "0d34c3d7c6b71886e601999468f5b95a7bb3ecf62475e63ce07e0b72eaee3adb"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.6.0/sdrmm-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "c5f1964311cf236066c1505761795284af9e0a5cc4fb1e1f3fb9ef8568f65de4"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.6.0/sdrmm-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f73314dd4a2669aec71c64c9eca9db6f52a2e56553ac29f49f01376dd2f36c86"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.6.0/sdrmm-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab8bba6e56a50e99746edded59e31ed4bc6be35bc69bd28aa56afdfcc8541914"
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
