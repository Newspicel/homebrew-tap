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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.3/sdrmm-1.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "1252609e6de489a4afa0897955889db3e1cd898616b6ed41d9df46bb8847bb9b"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.3/sdrmm-1.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "6bb2d474dfa556a2da25370e4f6333f8649d254632ba74dae650c27c3af171b9"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.3/sdrmm-1.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f1de5107f62d7bdeb7ca11920d79aa73b395a58f02e0a1bd9fe419d5eec3251"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.3/sdrmm-1.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ad39dcef0eb5b733e891c80484d4751b7016b4fee9ad4df5a8c928e2338125ad"
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
