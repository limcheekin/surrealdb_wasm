VERSION=$(grep 'version:' pubspec.yaml | cut -d ' ' -f 2)
echo "Current version: $VERSION"
BASE_VERSION=$(echo $VERSION | cut -d'+' -f1)
NEW_VERSION="$BASE_VERSION+$GITHUB_RUN_NUMBER"
echo "New version: $NEW_VERSION"
sed -i "s/version: $VERSION/version: $NEW_VERSION/g" pubspec.yaml
cat pubspec.yaml