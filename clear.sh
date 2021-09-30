# clear cached artifacts/dependencies                                                                                                    1 ✘  20s  20:32:19
rm -rf ~/Library/Developer/Xcode/DerivedData/
rm -rf ~/Library/Caches/CocoaPods/
rm -rf clone/ios/Pods/
pod cache clean --all

# clear flutter - skip the next 3 lines if you're not using flutter
flutter clean
flutter pub get
cd ios

# run pod install
rm Podfile.lock
pod install --repo-update

cd ../