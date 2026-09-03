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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.0/sdrmm-0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "65a85ad521e7b0baab947635048e4f6b846f795268061c3da4f2264fb4e14dd8"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.0/sdrmm-0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "4e58751db3788a5813a309374e452f1dcd682417b9a8d7d716bbf9804c0f65c9"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.0/sdrmm-0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1863a0126da1996566443ae70892c7905e129bbe77a5c48c9f514e6ab22f0d63"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.8.0/sdrmm-0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7e8f2143ec2adb991bfdcea9a072addc99010342b77de288a5582ed2c370d75"
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
