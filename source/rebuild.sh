#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
upstream_dir=${1:?Usage: rebuild.sh <clean-upstream-source> <new-output-directory>}
output_dir=${2:?Usage: rebuild.sh <clean-upstream-source> <new-output-directory>}
expected_commit=3faf4baf56c7ba582290469cc475a385b6bc2ec9
expected_source_record_sha=e167282581d401bb604a94549c135c01fe7ef6c7a2fc00554f56f885d2016f6e
source_record="$script_dir/UPSTREAM_SOURCE.md"

check_sha() {
  file_path=$1
  expected=$2
  actual=$(shasum -a 256 "$file_path" | awk '{print $1}')
  [ "$actual" = "$expected" ] || { echo "SHA-256 mismatch: $(basename "$file_path")" >&2; exit 1; }
}
check_sha "$source_record" "$expected_source_record_sha"
grep -Fxq 'Tag: refs/tags/4.7.7' "$source_record"
grep -Fxq "Commit: $expected_commit" "$source_record"
if [ -n "$(find "$upstream_dir" -name .git -print -quit)" ]; then
  echo 'upstream source must be a clean archive without .git metadata' >&2
  exit 1
fi
check_sha "$upstream_dir/main.js" 853c154a51f22e43a68770223d4139787aab6629390995b453b5fdc87f3e05b0
check_sha "$upstream_dir/styles.css" 2230529cec2a25076007403d00dbc0657de4f9c47703a6dfebf2674c3787f229
check_sha "$upstream_dir/manifest.json" 4eb84f7e1fab869a0f0db4ef2aff07810686b3bf679f6cb0639e46ce593fb9ea
check_sha "$upstream_dir/LICENSE" 605e9047a563c5c8396ffb18232aa4304ec56586aee537c45064c6fb425e44ad

if [ -e "$output_dir" ]; then
  if [ ! -d "$output_dir" ] || [ -n "$(find "$output_dir" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
    echo 'output directory must be absent or empty' >&2
    exit 1
  fi
else
  mkdir -p "$output_dir"
fi
cp "$upstream_dir/main.js" "$upstream_dir/styles.css" "$upstream_dir/manifest.json" "$upstream_dir/LICENSE" "$output_dir/"
patch --batch --forward -p1 -d "$output_dir" < "$script_dir/patches/main.js.patch"
patch --batch --forward -p1 -d "$output_dir" < "$script_dir/patches/manifest.json.patch"

check_sha "$output_dir/main.js" 0451d96fa87b4c26baa659decd7a8cb415c7304c275945d42a7e580aef877eca
check_sha "$output_dir/styles.css" 2230529cec2a25076007403d00dbc0657de4f9c47703a6dfebf2674c3787f229
check_sha "$output_dir/manifest.json" b5a06b404d6e8ebd5bc1beb2aa9c00a552833a2d21543a5fe180733795a9ae61
check_sha "$output_dir/LICENSE" 605e9047a563c5c8396ffb18232aa4304ec56586aee537c45064c6fb425e44ad
printf '%s\n' 'Reconstruction verified: main.js, styles.css, manifest.json, LICENSE.'
