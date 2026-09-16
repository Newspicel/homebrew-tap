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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.4/sdrmm-1.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "51534e7bebe936c6c98f3b35934003a19a0dc304fc6c57f5d28c0305a959c7ae"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.4/sdrmm-1.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "c9cc5367f3b8b02d396041d8b83b734d357ea241ab827f71eef2bffff4d08267"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.4/sdrmm-1.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ac663751d22ddb8c73edc2d8c7d424a78f4433475174eb95d4d01cb33093c942"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.4/sdrmm-1.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b417cde0f2e49de09ee6936640b14ab05979ca87e342768b8ab5822ecff44c59"
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
