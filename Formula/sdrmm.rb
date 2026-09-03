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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.1/sdrmm-0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "eb55d746cb6b9bb3852654fb4442c911b2fcd6b74abe1bc37563c2e485b31b5c"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.1/sdrmm-0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "e0a9fac5cd33ad32c2ba588be49edefea4cce0f13f866404f5e68f4159ef15c4"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.1/sdrmm-0.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bc90e4021f7209e9d96c66a9a6c0322bd4ce9e65d55644a6f0017ece89ab1fc7"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.1/sdrmm-0.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f5d6b453157527e54a72049260dc1333f595685dab8da8f8a00cefbea5f9f1a3"
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
