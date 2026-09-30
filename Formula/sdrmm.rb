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
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.9.0/sdrmm-1.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "c89a6eee4862ddb2668c18dfdb63dc89e0c5fa3090302f6268be7ac75fbfe2fe"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.9.0/sdrmm-1.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "9192df557150b541b71ba8823849f71c4123938b260878c39e417a3e6f852f29"
    end
  end

  on_linux do
    depends_on "patchelf" => :build

    on_arm do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.9.0/sdrmm-1.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d453a5038f6e73b53b84c3da7f20b549d96769a8d2c9e0afccdbe0151f6aa467"
    end
    on_intel do
      url "https://github.com/Newspicel/sdrminusminus/releases/download/v1.9.0/sdrmm-1.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c27f867ca2bbc38f3a59ea164439f3e76189f064083943043adff5139df9afff"
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
