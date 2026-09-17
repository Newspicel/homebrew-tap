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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.2.0/sdrmm-1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "c07b81d973ddd302ea91b4bc50ecb22bec1086a43d7dcde29a33de38ff3d5544"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.2.0/sdrmm-1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "f176559f1db499dc815b87da6e6fc9dd70235e5bc822e39b935d5ff30ed8e76e"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.2.0/sdrmm-1.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4ea640b4dee3c33ddbbe9ba6cc5cc94475ce40bdd2cf5c3ce6ed1025fa4f785c"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.2.0/sdrmm-1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6a2baebbf488ed902edc6e63e1cb00178c9da3192e5fa4f21ecd94ca0383e6c"
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
