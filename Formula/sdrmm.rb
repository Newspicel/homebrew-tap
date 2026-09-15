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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.1/sdrmm-1.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "64a0b38a54945a612c410c132a0931cabcee2fb5f6eb13a42d5eb64a5ce72b7c"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.1/sdrmm-1.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "bad6881cb720701312cb752a1dc62106ad223a4fc4b8aae611b3dfb58e93fd60"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.1/sdrmm-1.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ac1681c06e67e4fa4bf768255d54163e96704b8c62ca7cd1c1cb3363197d68a"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.1.1/sdrmm-1.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dd1858f4dd800d5c927842d7917e75f0c45cf57a0da9a0cd9bbd684624b9b09d"
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
