cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.0"
  sha256 arm:   "eab1f956058b86de3a0e4bc499ad2c8c30407069161d89f2fbee3eb90ec70b7b",
         intel: "016e176710c86afd808291156af202d7e03ada72ddc4729f49195d73fea21846"

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
