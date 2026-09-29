cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "1.8.1"
  sha256 arm:   "621f7daec897a1a354785dd87b2673f8173462e4ee82f8fc019aa1fa7d58f72a",
         intel: "f1d37eec076f620f966be45740b94b71656a38d61bbe9d08868029745e3bdf40"

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
