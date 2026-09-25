cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "103420124311631736b47c3939262b444d019b5401edcdd8a9da3983328e0e57",
         intel: "3e839cfe2618ef04e7edca7d1eadd15458ebd74180d3e5f6342d2bd96a17c905"

  url "https://github.com/Newspicel/sdrminusminus/releases/download/v#{version}/SDR--_#{version}_#{arch}.dmg"
  name "SDR--"
  name "sdr minus minus"
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"

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
