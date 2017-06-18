sudo xcode-select --switch /Applications/Xcode-beta.app/
swift build
cp .build/debug/timer /usr/local/bin/timer
#reset
sudo xcode-select --switch /Applications/Xcode.app/
