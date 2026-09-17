cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "1.2.0"
  sha256 arm:   "cb897b1d8a7c719589e4b7dc16b26810528c00a5041f1721b74b8899135b4dc9",
         intel: "2871c2aecb6822a3e56ab454296b363b172123805b5e0ee6ab4ef7207146ad38"

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
