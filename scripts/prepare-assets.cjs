#!/usr/bin/env node
'use strict';
// Keep editable source readable, ship compact static assets. No router tooling.
const fs = require('node:fs');
const path = require('node:path');
const [out, tools] = process.argv.slice(2);
if (!out || !tools) throw new Error('Usage: prepare-assets.cjs OUTPUT ESBUILD_MODULE');
const esbuild = require(tools);
const base = path.resolve(__dirname, '..');
const source = path.join(base, 'luci-theme-modemskin/htdocs');
const report = [];
function prepare(dir, dest) {
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.name.startsWith('.')) continue;
    const from = path.join(dir, entry.name);
    const to = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      prepare(from, to);
    } else if (/\.(css|js)$/.test(entry.name)) {
      const input = fs.readFileSync(from, 'utf8');
      const result = esbuild.transformSync(input, {
        loader: path.extname(entry.name).slice(1),
        minify: true,
        legalComments: 'inline',
        target: 'es2018'
      });
      fs.writeFileSync(to, result.code);
      report.push({ file: path.relative(source, from), sourceBytes: Buffer.byteLength(input), packageBytes: Buffer.byteLength(result.code) });
    } else {
      fs.copyFileSync(from, to);
    }
  }
}
prepare(source, out);
fs.writeFileSync(path.join(path.dirname(out), 'asset-sizes.json'), JSON.stringify(report, null, 2) + '\n');
console.log(JSON.stringify(report));
