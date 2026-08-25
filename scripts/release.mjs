import fs from "node:fs";
import { execFileSync } from "node:child_process";

const packagePath = new URL("../package.json", import.meta.url);
const packageJson = JSON.parse(fs.readFileSync(packagePath, "utf8"));
const currentVersion = packageJson.version;

function git(...args) {
  return execFileSync("git", args, { encoding: "utf8", stdio: ["ignore", "pipe", "inherit"] }).trim();
}

const match = /^(\d+)\.(\d+)\.(\d+)$/.exec(currentVersion);
if (!match) {
  console.error(`Invalid package version: ${currentVersion}`);
  process.exit(1);
}

const nextVersion = `${match[1]}.${match[2]}.${Number(match[3]) + 1}`;
const nextTag = `v${nextVersion}`;

if (git("tag", "--list", nextTag) === nextTag) {
  console.error(`Git tag ${nextTag} already exists.`);
  process.exit(1);
}

if (git("status", "--porcelain")) {
  git("add", "--all");
  git("commit", "-m", "chore: commit pending changes");
}

packageJson.version = nextVersion;
fs.writeFileSync(packagePath, `${JSON.stringify(packageJson, null, 2)}\n`);

git("add", "package.json");
git("commit", "-m", `chore: release ${nextTag}`);
git("tag", "--annotate", nextTag, "--message", `Release ${nextTag}`);
git("push", "--follow-tags", "origin", "HEAD");

console.log(`Release ${nextTag} pushed. GitHub Actions will build ghcr.io/piitschy/sprachimbiss:${nextVersion}.`);
