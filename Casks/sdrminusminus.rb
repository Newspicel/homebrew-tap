cask "sdrminusminus" do
  arch arm: "aarch64", intel: "x64"

  version "1.1.4"
  sha256 arm:   "dd88fc13ad3ca3a88c93ddf5c14f70a5f177ecef38b4db0c9d477a2ae7bfa43a",
         intel: "2e240ba049e81588b9fa222b06af122b0dce5f3529aa6bac3a507f57fd8d3403"

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
