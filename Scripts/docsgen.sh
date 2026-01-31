#!/bin/sh

set -e
set -o pipefail

mkdir -p /tmp/derivedData /tmp/docc /tmp/symbols

xcodebuild docbuild -scheme PDUIKit \
  -configuration Release \
  -derivedDataPath /tmp/derivedData \
  -destination 'platform=macOS' \
  -toolchain "swift latest" \
  -skipPackagePluginValidation \
  -skipMacroValidation;

echo "Copying symbols..."
cp -r /tmp/derivedData/Build/Intermediates.noindex/*.build/Release/*.build/symbol-graph/ /tmp/symbols
rm -rf /tmp/symbols/swift* /tmp/symbols/playdatekit /tmp/symbols/utf8viewextensions

xcrun docc convert "./PDKUtils.docc" \
  --output-dir /tmp/docc/PDUIKit.doccarchive \
  --additional-symbol-graph-dir /tmp/symbols

$(xcrun -f docc -toolchain "swift latest") process-archive \
  transform-for-static-hosting /tmp/docc/PDUIKit.doccarchive \
  --hosting-base-path . \
  --output-path docs;

echo "<script>window.location.href += \"/documentation/overview\"</script>" > docs/index.html;