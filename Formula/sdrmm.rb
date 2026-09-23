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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.5.0/sdrmm-1.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "94d4e37516e28cab98272fcaa81e8b339190297ecedbcce39f658a9e97b8d2d6"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.5.0/sdrmm-1.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "f34c9f552ea7ea603cae570c6f1cf1cc104e10a7bab5fe7cec0bc7c304971abf"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.5.0/sdrmm-1.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a7c81ab2c51ecd32a0dbf11b853be013c67a37ef6861241e1944faa4b322f18"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.5.0/sdrmm-1.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d9820d734244eca655be9c5f542f622544c5434c09fd1ddb02a0410db15e269d"
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
