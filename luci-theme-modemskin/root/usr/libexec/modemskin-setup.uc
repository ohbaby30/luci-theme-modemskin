// ModemSkin setup: read committed files only; preserve the legacy package/config.
'use strict';
import { cursor } from 'uci';
const uc = cursor();
if (!uc.load('/etc/config/modemskin')) exit(1);
if (uc.get('modemskin', 'main', 'migration_pending') == '1') {
    // A pending marker belongs to a newly unpacked factory config, not upgrades.
    if (uc.get('modemskin', 'main', 'skin') == 'telecom' && uc.load('/etc/config/ctmodem_tricolor')) {
        const old = uc.get('ctmodem_tricolor', 'main', 'skin');
        if (old == 'telecom' || old == 'unicom' || old == 'mobile')
            uc.set('modemskin', 'main', 'skin', old);
    }
    uc.delete('modemskin', 'main', 'migration_pending');
    if (!uc.commit('modemskin')) exit(1);
}
if (!uc.load('/etc/config/luci')) exit(0);
uc.set('luci', 'themes', 'ModemSkin', '/luci-static/modemskin');
if (uc.get('luci', 'main', 'mediaurlbase') == '/luci-static/ctmodem-tricolor')
    uc.set('luci', 'main', 'mediaurlbase', '/luci-static/modemskin');
if (!uc.commit('luci')) exit(1);
