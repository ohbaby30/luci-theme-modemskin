# Third-party copyright and licenses

## hakureiyuyuko/luci-theme-ctmodem

- Upstream: https://github.com/hakureiyuyuko/luci-theme-ctmodem
- Reference revision: e74b366701c97a10c1b2f94057f21c46cfadbf4f
- Original license: https://github.com/hakureiyuyuko/luci-theme-ctmodem/blob/e74b366701c97a10c1b2f94057f21c46cfadbf4f/LICENSE
- License: MIT

ModemSkin retains material from this upstream project. The following paths
contain upstream material or modifications derived from it. Listing a file does
not assign all contributions in that file to the upstream author; Ohbaby's
original contributions and modifications are covered by the root LICENSE.

Paths are relative to luci-theme-modemskin/:

| Files or group | Retained material |
| --- | --- |
| htdocs/luci-static/modemskin/cascade.css | Shared base styles, with compatibility and layout modifications. Used by all three appearances. |
| htdocs/luci-static/modemskin/menu-modemskin.js | Navigation implementation derived from the upstream menu, with substantial changes. |
| ucode/template/themes/modemskin/header.ut | Shared page template derived from the upstream header. |
| ucode/template/themes/modemskin/footer.ut | Shared page template derived from the upstream footer. |
| ucode/template/themes/modemskin/sysauth.ut | Login form/template derived from the upstream login page. |
| htdocs/luci-static/modemskin/logo.svg | Retained upstream asset. |
| htdocs/luci-static/modemskin/img/back_button.jpg | Retained image. |
| htdocs/luci-static/modemskin/img/button_bg.gif | Retained image. |
| htdocs/luci-static/modemskin/img/framelogo.jpg | Retained image. |
| htdocs/luci-static/modemskin/img/login_inupt.gif | Retained image. |
| htdocs/luci-static/modemskin/img/selected_button.jpg | Retained image. |
| htdocs/luci-static/modemskin/img/top_img_20K.jpg | Retained image. |
| Makefile and any other retained upstream fragments | Applicable upstream notices remain in force for retained portions. |

The notice is not limited to telecom.css: common templates, navigation and base
styles are also used by the Unicom and Mobile appearances. See NOTICE.md for
provenance, original modifications and independently drawn additions.

### Original copyright and full MIT license

The following is the upstream LICENSE text, retained without modification:

```text
MIT License

Copyright (c) 2026 hakureiyuyuko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Device graphics and brand identifiers

The upstream project describes the modem interface cutouts as original device
resources. Retaining the upstream software license does not establish ownership
of those third-party resources or grant additional trademark/brand permissions.
Relevant rights remain with their respective owners. ModemSkin is an independent
LuCI theme and does not imply endorsement by a carrier or device manufacturer.

## Distribution

Distribute this file together with LICENSE and NOTICE.md. The native APK/IPK
builders install all three files into /usr/share/doc/luci-theme-modemskin/.
When redistributing substantial retained portions separately, include the
applicable original copyright and permission notice as required by MIT.
