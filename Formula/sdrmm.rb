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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.1/sdrmm-1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "2f40711fc9aabeed64f96521e223abcbefb17e92b5e85dbc7db422f56cc85ed2"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.1/sdrmm-1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "c00efa83bc1d653279e88cbcc7d97d96d652dfea820b93210547d40e6b116ecd"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.1/sdrmm-1.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ef70d9bf2ca3da661f3071ad5a7e932a4acff6613492a358c0d43a520a84bc8b"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.0.1/sdrmm-1.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "40fb466b42ada5d357dbd1e7ecdd25a7ad15a3c306c7514ca8de1f0bc1e9d689"
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
