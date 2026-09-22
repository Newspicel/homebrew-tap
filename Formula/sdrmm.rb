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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.4.0/sdrmm-1.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "421702a8afad444fba852dfa57a9e75832368fd1c768cce23374a05b29e31aed"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.4.0/sdrmm-1.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "ed085c3e566ae44da31f7bbecff4ab43cc52fb5304e03752e69eddc5d1e24cb0"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.4.0/sdrmm-1.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a55622468bcfa7a08cfb11a4f00b0e2f0993c13d15a799a425ef4ef45a437023"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.4.0/sdrmm-1.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d2a139b8e8be751bdb62e9935e4cc67d243c998a23e92d3af83091b9f421fbcf"
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
