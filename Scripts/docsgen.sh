#!/bin/sh

set -e
set -o pipefail

mkdir -p /tmp/derivedData /tmp/docc

xcodebuild docbuild -scheme PDUIKit \
  -configuration Release \
  -derivedDataPath /tmp/derivedData \
  -destination 'platform=macOS' \
  -toolchain "swift latest" \
  -skipPackagePluginValidation \
  -skipMacroValidation;

xcrun docc merge $(find /tmp/derivedData -type d -name 'PD*.doccarchive') \
  --synthesized-landing-page-name PDKUtils \
  --synthesized-landing-page-kind SDK \
  --output-path /tmp/docc/PDKUtils.doccarchive

$(xcrun -f docc -toolchain "swift latest") process-archive \
  transform-for-static-hosting /tmp/docc/PDKUtils.doccarchive \
  --hosting-base-path . \
  --output-path docs;

echo "<script>window.location.href += \"/documentation\"</script>" > docs/index.html;

rm -rf /tmp/derivedData /tmp/docc