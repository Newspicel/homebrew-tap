class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "soapysdr"

  on_macos do
    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.0/sdrmm-1.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "f16662c05422c288d75b5850872a487a1a68e8adcc36671880153d30a2ebe841"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.0/sdrmm-1.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "72a9ce8a612005f772a08e284291e6a759ab090a18cbde02a890600213483799"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.0/sdrmm-1.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6781c38d5caf71dfa7d2be90f39611977c0061898d384499ce08a64a4f8b11e3"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.0/sdrmm-1.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aedf0b197285a98849f2f03ca410684ffc03273bf80818d4530eb5b7b567e5c4"
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
