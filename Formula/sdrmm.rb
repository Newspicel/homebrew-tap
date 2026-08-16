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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.0/sdrmm-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "19c519e0762ee7c1457e0f760d90caf947d564d1aa100537fa52aed03b92a839"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.0/sdrmm-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "9e801edb6013c6e429d40131b0d5bf669b295decff19b695fb796bb449166b34"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.0/sdrmm-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "851f2b306fd51f09a0f235a2e48ae94a5610fc0db26b0f2664cf69599a526721"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.0/sdrmm-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9094a679da59d7c9cca9e2b6750eadf7524e0cb55228fdd3a2da21cec2a05730"
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
