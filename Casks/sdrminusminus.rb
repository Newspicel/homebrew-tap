cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.0"
  sha256 arm:   "a68e2d0881e2e333baa2d943be837fc7830869cd4102400e9301d9a6a526f2f7",
         intel: "ada2109a66e0b0f81e1d13d767da1e155e7175f058947a89b99a2419f76d41a6"

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
