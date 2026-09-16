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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.5/sdrmm-1.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "71b2467c957c9e8cbe1993b80c1e2b84d7a75197485f26b61a67813991d724b1"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.5/sdrmm-1.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "68d35c54417653ce1d991317f050c7c7fd740c63431b83ff5fc8fc7f087f1d0b"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.5/sdrmm-1.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05b8319cb475bf0cc5fc0acad4fc96be43d8c3553d696527b43fa11e99cab0f3"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.5/sdrmm-1.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3be2982479b42ca044a2eeb45b779cfe8a1ce60794eb3fd20bc1a0af5371900"
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
