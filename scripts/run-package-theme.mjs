import { spawnSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const scriptPath = path.join(__dirname, "package-theme.ps1");
const isWindows = process.platform === "win32";
const command = isWindows ? "powershell" : "pwsh";
const args = isWindows
  ? ["-ExecutionPolicy", "Bypass", "-File", scriptPath]
  : ["-File", scriptPath];

const result = spawnSync(command, args, {
  cwd: path.join(__dirname, ".."),
  stdio: "inherit",
});

if (result.error) {
  throw result.error;
}

if (typeof result.status === "number" && result.status !== 0) {
  process.exit(result.status);
}
