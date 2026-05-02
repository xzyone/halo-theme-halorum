// @ts-check
import { defineConfig } from "astro/config";

export default defineConfig({
  base: "/themes/halorum",
  build: {
    assets: "assets",
    format: "file",
  },
  outDir: "./templates",
});
