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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.0/sdrmm-1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "5b57ec3629d85098c0c1beaa93355128ffa8d99dae79ae8b89c4eb158b275bf6"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.0/sdrmm-1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "32f6a75a15a1a0c142298fa0d6000a148933b52a34aed4d59194d6686d488774"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.0/sdrmm-1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3fde2bd547d90b528870f596f30ba5296d182503cca5c3364aa985d5d64064a9"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.0/sdrmm-1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99245fae1e080c535342d2df30bf8578396d6e829505708372a07994d421c40b"
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
