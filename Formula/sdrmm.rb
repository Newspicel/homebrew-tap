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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.7.0/sdrmm-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "c1acf05616a35ae98601ed70603644f20e087d7fa4cdc4f7e8b981dea49abc28"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.7.0/sdrmm-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "3c3c2368837f07c571fdce9b940ae1e36070da60ea3e6f8286127634f6f93a3e"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.7.0/sdrmm-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1bb8f05138325cc7fda8f6dd288f7d1cbe659a0cac3a50271d2a333b83c3cfb1"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.7.0/sdrmm-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e151ef9357b57dec69d698adb053db22de82c00eea987434c1c2372e570dc495"
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
