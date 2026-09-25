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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.7.0/sdrmm-1.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "1e7882096052c7f1f91b2b01bd7889662f913a00b19f8ddab0abc72fb34b1257"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.7.0/sdrmm-1.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "d7728145fd75350c99031341eb24d44ad554e34953e1ce777740539feb3aec5c"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.7.0/sdrmm-1.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9349e4feb83013cf61b2f4c9066b38641c2dc8376374f8af4a7d89ad521e3eb6"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.7.0/sdrmm-1.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1c6554f5c51389d6f26fef8a899df83a50b95761fb1b9fe52a698f3ba3ff0640"
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
