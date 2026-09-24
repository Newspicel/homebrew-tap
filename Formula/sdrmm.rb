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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.6.0/sdrmm-1.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "64c97afe18d521b1f66ea774d8e47dbaa0945518a25a048ea0f984ed9b5816cc"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.6.0/sdrmm-1.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "d5a3ab428f6366fd9a4c99461254d5880f63d5c69e8afb8bab212040692cc69c"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.6.0/sdrmm-1.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "26e7fb236d42f17a330c17bd52f3d5d7b61e6d4aae582ce9444edb1990a9d669"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.6.0/sdrmm-1.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "902719cf7e4aada1f60c02356615a10fda9efc81761789951e7ff6dde5512d6c"
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
