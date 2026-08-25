import fs from "node:fs";
import { execFileSync } from "node:child_process";

const packagePath = new URL("../package.json", import.meta.url);
const packageJson = JSON.parse(fs.readFileSync(packagePath, "utf8"));
const currentVersion = packageJson.version;

function git(...args) {
  return execFileSync("git", args, { encoding: "utf8", stdio: ["ignore", "pipe", "inherit"] }).trim();
}

if (git("status", "--porcelain", "--", "package.json")) {
  console.error("package.json has uncommitted changes; refusing to release.");
  process.exit(1);
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

packageJson.version = nextVersion;
fs.writeFileSync(packagePath, `${JSON.stringify(packageJson, null, 2)}\n`);

git("add", "package.json");
git("commit", "-m", `chore: release ${nextTag}`);
git("tag", "--annotate", nextTag, "--message", `Release ${nextTag}`);
git("push", "origin", "HEAD");
git("push", "origin", nextTag);

console.log(`Release ${nextTag} pushed. GitHub Actions will build ghcr.io/piitschy/sprachimbiss:${nextVersion}.`);
