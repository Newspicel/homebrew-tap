cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "1.9.0"
  sha256 arm:   "9ee93f9654291791e421f6776e953f17f9966add3e76ec7bae123d00a5c18ad6",
         intel: "ac18fb974beca1ba605c006b1ef1c9646574eeca76aa0df9a9382a5407db37ad"

  url "https://github.com/Newspicel/sdrminusminus/releases/download/v#{version}/SDR--_#{version}_#{arch}.dmg"
  name "SDR--"
  name "sdr minus minus"
  desc "Modular, client-server software-defined radio"
  homepage "https://sdrmm.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :big_sur

  app "SDR--.app"

  zap trash: [
    "~/Library/Application Support/dev.newspicel.sdrmm",
    "~/Library/Caches/dev.newspicel.sdrmm",
    "~/Library/HTTPStorages/dev.newspicel.sdrmm",
    "~/Library/Preferences/dev.newspicel.sdrmm.plist",
    "~/Library/Saved Application State/dev.newspicel.sdrmm.savedState",
    "~/Library/WebKit/dev.newspicel.sdrmm",
  ]
end
