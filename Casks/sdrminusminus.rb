cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "31445a89e994bb592c4c59a1956bdf9d6e233f8fc51139169a1e63b75fdabfdb",
         intel: "bf7684d02d906b739d29899891597bc5cb7a89f18cbf136114ea00fb9bb8d3a0"

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
