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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.9.0/sdrmm-0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "7b05a7ee4a81467d14ab376b98c293f40d5af349df5feaee997702a6999c09a8"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.9.0/sdrmm-0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "de807c360d00544cfe1ab5003c5fd0822ba130c266a5df4861429bf9fe5efdec"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.9.0/sdrmm-0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fcb3be6d08d0f16fd2bfbf475b04d967c3fed9d72ebecc34d29cd41c1fc27e53"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v0.9.0/sdrmm-0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e03db4120c6526e537c07952f357f4f915468b4e440790f3579abfba148397a0"
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
