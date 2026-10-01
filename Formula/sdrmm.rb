class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://sdrmm.com"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "soapysdr"

  on_macos do
    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.0.0/sdrmm-2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "4ca4663415c701dc4697f5ad764efd8997f27522e31b0b6a69feb3f0a1634426"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.0.0/sdrmm-2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "96dd45b7f6e8f680ebfd06f8bb3afa5b826d90db7f268f112b3770a3e7dae461"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.0.0/sdrmm-2.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cb13eaec3fcaf520e38618c0d3fe74700c9b5866e75d34f291cd08256a3506a9"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v2.0.0/sdrmm-2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c0df066fbe19030c644f09002dc6d64dc2fef826ced050ed025269b252812ab9"
    end
  end

  def install
    bin.install "sdrmm"
    (lib/"sdrmm").install Dir["*.dylib", "*.so*"]
    doc.install "LICENSE", "README.md", "THIRD_PARTY_NOTICES.md"

    if OS.mac?
      MachO::Tools.add_rpath(bin/"sdrmm", formula_opt_lib("soapysdr").to_s)
      system "codesign", "--sign", "-", "--force", bin/"sdrmm"
    else
      system formula_opt_bin("patchelf")/"patchelf",
             "--set-rpath", "#{formula_opt_lib("soapysdr")}:#{lib}/sdrmm", bin/"sdrmm"
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
