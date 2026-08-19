cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.0"
  sha256 arm:   "da3331d5fdb626454954c4d7d6bbe59b6547881322b92291becd1848f38b5999",
         intel: "12f7dde89e0429e2e80ede16fef9c400acc5c66693fcfe9abb05ad237eff74fc"

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
