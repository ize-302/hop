#!/bin/bash
# Releases hop: bumps VERSION, dates the changelog, tags, pushes and
# creates the GitHub release. The notes are CHANGELOG.md's [Unreleased].
#
#   ./release.sh patch|minor|major   bump the version
#   ./release.sh 1.2.3               release this exact version
#   ./release.sh minor --dry-run     check and preview, change nothing
#
# Run it on main, up to date with origin, with nothing uncommitted.
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

dry=
bump=
for arg in "$@"; do
  case "$arg" in
  --dry-run) dry=1 ;;
  -h | --help)
    sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
  -*)
    echo "Unknown option: $arg (see --help)" >&2
    exit 1
    ;;
  *) bump=$arg ;;
  esac
done

say() { echo "[+] $*"; }
note() { echo "[!] $*"; }
die() {
  note "$*"
  exit 1
}

[ -n "$bump" ] || die "Say which version: patch, minor, major or x.y.z (see --help)."

# --- Checks -------------------------------------------------------------------

[ "$(git branch --show-current)" = main ] || die "Release from main (git switch main)."
[ -z "$(git status --porcelain)" ] || die "Commit or stash your changes first."
git fetch -q origin main --tags
[ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ] ||
  die "main isn't the same as origin/main: pull or push first."
command -v gh >/dev/null || die "gh isn't installed (pacman -S github-cli)."
gh auth status >/dev/null 2>&1 || die "gh isn't logged in (gh auth login)."
for f in hop install; do
  bash -n "$f" || die "$f has a syntax error."
done

# The compare link gives the repo's URL, so it isn't written here twice
link=$(grep -m1 '^\[Unreleased\]: ' CHANGELOG.md || true)
[ -n "$link" ] || die "CHANGELOG.md has no [Unreleased]: link line at the bottom."
base=${link#*: }
base=${base%/compare/*}

# Entries under ## [Unreleased], up to the next version or the link lines
notes=$(awk '/^## \[Unreleased\]/{f=1;next} /^## \[|^\[[^]]+\]: /{f=0} f' CHANGELOG.md | sed '/./,$!d')
grep -q '^- ' <<<"$notes" || die "Nothing under ## [Unreleased] in CHANGELOG.md to release."

# --- Version ------------------------------------------------------------------

current=$(cat VERSION)
semver='^([0-9]+)\.([0-9]+)\.([0-9]+)$'
[[ $current =~ $semver ]] || die "VERSION isn't x.y.z: $current"
major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} patch=${BASH_REMATCH[3]}
case "$bump" in
patch) new=$major.$minor.$((patch + 1)) ;;
minor) new=$major.$((minor + 1)).0 ;;
major) new=$((major + 1)).0.0 ;;
*)
  [[ $bump =~ $semver ]] || die "Not a version: $bump (patch, minor, major or x.y.z)"
  new=$bump
  ;;
esac
[ "$new" != "$current" ] && [ "$(printf '%s\n' "$current" "$new" | sort -V | tail -1)" = "$new" ] ||
  die "$new isn't newer than $current."
tag=v$new

git rev-parse -q --verify "refs/tags/$tag" >/dev/null && die "Tag $tag already exists."
git ls-remote --exit-code --tags origin "refs/tags/$tag" >/dev/null && die "Tag $tag is already on GitHub."

ask() {
  read -rp "    $1 [y/N] " answer || answer=
  case "$answer" in
  [yY] | [yY][eE][sS]) ;;
  *)
    say "Nothing was changed."
    exit 1
    ;;
  esac
}

# Before 1.0 a breaking change needs a minor bump, after it a major one
[[ $new =~ $semver ]]
if grep -q '^### Breaking' <<<"$notes" && [ "${BASH_REMATCH[1]}" = "$major" ] &&
  { [ "$major" -gt 0 ] || [ "${BASH_REMATCH[2]}" = "$minor" ]; }; then
  note "There's a Breaking section, but $current to $new doesn't say so."
  [ -n "$dry" ] || ask "Release $new anyway?"
fi

say "Releasing $current to $new, with these notes:"
sed 's/^/      /' <<<"$notes"

if [ -n "$dry" ]; then
  say "Dry run done: nothing was changed."
  exit 0
fi
ask "Release $new?"

# --- Release ------------------------------------------------------------------

printf '%s\n' "$new" >VERSION
awk -v new="$new" -v today="$(date +%F)" -v base="$base" '
  /^## \[Unreleased\]/ { print; print ""; print "## [" new "] - " today; next }
  /^\[Unreleased\]: / {
    print "[Unreleased]: " base "/compare/v" new "...HEAD"
    print "[" new "]: " base "/releases/tag/v" new
    next
  }
  { print }
' CHANGELOG.md >CHANGELOG.md.new
mv CHANGELOG.md.new CHANGELOG.md

git commit -q -m "chore: release $new" VERSION CHANGELOG.md
git tag -a "$tag" -m "hop $new"
say "Committed and tagged $tag"

# --atomic: main and the tag go up together or not at all
if ! git push -q --atomic origin main "$tag"; then
  note "Couldn't push, so nothing left your machine. To undo the release:"
  note "  git tag -d $tag && git reset --hard HEAD~1"
  exit 1
fi
say "Pushed main and $tag"

notes_file=$(mktemp --suffix=.md)
printf '%s\n' "$notes" >"$notes_file"
if ! gh release create "$tag" --title "hop $new" --notes-file "$notes_file" --verify-tag; then
  # The tag is public now: don't move it, just make the release by hand
  note "$tag is pushed but the GitHub release failed. Make it with:"
  note "  gh release create $tag --title \"hop $new\" --notes-file $notes_file --verify-tag"
  exit 1
fi
rm -f "$notes_file"
say "Released hop $new"
