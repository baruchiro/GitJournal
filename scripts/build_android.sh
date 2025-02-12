#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2019-2021 Vishesh Handa <me@vhanda.in>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eux pipefail

BUILD_NUM=$(git rev-list --count HEAD)
echo "Build Number: $BUILD_NUM"

# flutter build appbundle --flavor prod --build-number="$BUILD_NUM" --dart-define=INSTALL_SOURCE=playstore

BUILD_ID=$(make version | tail -n 1 | awk '{ print $4 }')

# Also building the apk, as it's useful for non Google Play users
flutter build apk --flavor dev --debug --build-number="$BUILD_NUM" --dart-define=INSTALL_SOURCE=fdroid
cp build/app/outputs/flutter-apk/app-dev-debug.apk baruchiro.gitjournal_$BUILD_ID.apk

# flutter build apk --flavor dev --build-number="$BUILD_NUM" --dart-define=INSTALL_SOURCE=fdroid
# cp build/app/outputs/flutter-apk/app-dev-release.apk baruchiro.gitjournal.dev_$BUILD_ID.apk
