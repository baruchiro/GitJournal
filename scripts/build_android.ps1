$BUILD_NUM = git rev-list --count HEAD
Write-Host "Build Number: $BUILD_NUM"

flutter build appbundle --flavor prod --build-number="$BUILD_NUM" --dart-define=INSTALL_SOURCE=playstore

flutter build apk --flavor prod --build-number="$BUILD_NUM" --dart-define=INSTALL_SOURCE=fdroid
