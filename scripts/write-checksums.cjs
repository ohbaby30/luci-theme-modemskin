'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const output = process.argv[2];
if (!output) throw new Error('Pass the package output directory');
const content = fs.readdirSync(output).filter(name => /\.(apk|ipk)$/.test(name)).sort().map(name =>
  crypto.createHash('sha256').update(fs.readFileSync(path.join(output, name))).digest('hex') + '  ' + name + '\n'
).join('');
// Container outputs may be root-owned on Linux. Replace via the caller-owned
// directory instead of opening an existing root-owned checksum file for writing.
const temporary = path.join(output, `.SHA256SUMS.${process.pid}.tmp`);
fs.writeFileSync(temporary, content, { flag: 'wx' });
try {
  fs.renameSync(temporary, path.join(output, 'SHA256SUMS'));
} finally {
  if (fs.existsSync(temporary)) fs.unlinkSync(temporary);
}
