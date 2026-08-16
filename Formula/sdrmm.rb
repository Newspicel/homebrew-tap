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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.1/sdrmm-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "286dbb322d3cd2ed5bf3a0eba91b682b78172a54d46217134be37b3baf1b8d74"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.1/sdrmm-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "5a15c25b8ea506d40aae31f553f4d796303d2769019e345119713d4e5c68830a"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.1/sdrmm-0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0bd30e8b08cd0708881777c4fb93eb1d9c46e696a32d7b02d13982eaa304562d"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.4.1/sdrmm-0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "871851a21f1518b0d565e6e95e9c088fcad72b53bf674cdc2316044ec253a05e"
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
