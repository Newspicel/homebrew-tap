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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.0/sdrmm-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "ffabe7a2fb07d22b772bf69cbceee4c7b7aa7b4fc4ffe3bdb60d495d6cc65fba"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.0/sdrmm-1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "5b22ce62262e7062bc36fba9aaffad236ddd86d61e77d343c005538bd783c2ae"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.0/sdrmm-1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2715b6453409b9b2072f85eb818321b721f9876d1ce5fe7c60f3b4567bceb0b0"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.0/sdrmm-1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2f893e7374470427e9b68243c934c768159aea45da09eaec6978831063209263"
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
