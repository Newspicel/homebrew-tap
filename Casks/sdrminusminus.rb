cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "1.1.0"
  sha256 arm:   "8669ceadb80cdc603ab850e6514e978c914473d7ded6b7e77f5dcbf47e2664ad",
         intel: "e63efd41bfbd45e6f8cea44d85b83a9668f588fddddcb010fe05e9a6a98b11de"

  url "https://github.com/Newspicel/sdrminusminus/releases/download/v#{version}/sdr--_#{version}_#{arch}.dmg"
  name "sdr--"
  name "sdr minus minus"
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :catalina

  app "sdr--.app"

  zap trash: [
    "~/Library/Application Support/dev.newspicel.sdrmm",
    "~/Library/Caches/dev.newspicel.sdrmm",
    "~/Library/HTTPStorages/dev.newspicel.sdrmm",
    "~/Library/Preferences/dev.newspicel.sdrmm.plist",
    "~/Library/Saved Application State/dev.newspicel.sdrmm.savedState",
    "~/Library/WebKit/dev.newspicel.sdrmm",
  ]
end
