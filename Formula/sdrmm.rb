class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://sdrmm.com"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "soapysdr"

  on_macos do
    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.1/sdrmm-1.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "c39ed396b5450ebcef3e76a48364b3b82c4613c7506cba9ab968c4b25920f79c"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.1/sdrmm-1.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "a2fbe8121205b26f5710d44f4e8575d63ef497da9b853cbaa149cf6f758419ce"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.1/sdrmm-1.8.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d60a2a8a367447b6849c28b2cc59badbae09d92739df2b160b35f49868d75db8"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.8.1/sdrmm-1.8.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af0b838417c0b8fb535f6ada3067676179d51d9b5b3eeb44d42bbb925ba72be0"
    end
  end

  def install
    bin.install "sdrmm"
    (lib/"sdrmm").install Dir["*.dylib", "*.so*"]
    doc.install "LICENSE", "README.md", "THIRD_PARTY_NOTICES.md"

    if OS.mac?
      MachO::Tools.add_rpath(bin/"sdrmm", formula_opt_lib("soapysdr").to_s)
      system "codesign", "--sign", "-", "--force", bin/"sdrmm"
    else
      system formula_opt_bin("patchelf")/"patchelf",
             "--set-rpath", "#{formula_opt_lib("soapysdr")}:#{lib}/sdrmm", bin/"sdrmm"
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
