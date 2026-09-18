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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.3.0/sdrmm-1.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "93b5d0e78458b267a3593532069a643f7b3d659698dbafcea8c445f1cb7fd0d6"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.3.0/sdrmm-1.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "bf2ad8a978c10583e3e311dd0adbcc06549506c2027081864fe41403c669ef16"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.3.0/sdrmm-1.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ef0e94ab39da3de294e803056a2658cdcdbecc929e66b5e18c67498de3c1fe4"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.3.0/sdrmm-1.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3db0e0e4de1bb9845f1a820758a1e8200edea93ea49883085eba8d77f582881"
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
      RTL-SDR, HackRF, Airspy, Airspy HF+, RTL-TCP and SpyServer receivers are built in.
      Other hardware is reached through SoapySDR modules, which install separately:
        brew install soapybladerf soapyremote

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
