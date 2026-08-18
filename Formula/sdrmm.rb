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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.5.0/sdrmm-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "b304e8e71fcf8df2f41f1b32492ea8542327d7512ce7544cfeabc82f90ad004d"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.5.0/sdrmm-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "4083c43fafc693d698dff0cfecff53766ad65fd67282f72182c89c126896590a"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.5.0/sdrmm-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "676e4fb360f9a3cb7e893bddab7e5b6ac83788d2c49efa4f4a40b3ae105cf950"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.5.0/sdrmm-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ad5631894b2627e04028f9cc4e46b37bbbd48a2b20ba750c85a49ff7d8dd52c"
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
