// ModemSkin: fixed-purpose appearance save; no general UCI commit API.
// MIT License.
'use strict';
import { cursor } from 'uci';

return {
    'modemskin': {
        save: {
            args: { skin: '' },
            call: function(request) {
                const skin = request.args.skin;
                if (skin != 'telecom' && skin != 'unicom' && skin != 'mobile')
                    return { ok: false, error: 'invalid_skin' };

                // Absolute-path loading deliberately bypasses UCI delta overlays.
                // Only the committed file is read and updated, not CLI/session edits.
                const uc = cursor();
                if (!uc.load('/etc/config/modemskin'))
                    return { ok: false, error: 'config_unavailable' };
                if (!uc.get('modemskin', 'main'))
                    uc.set('modemskin', 'main', 'appearance');
                if (!uc.set('modemskin', 'main', 'skin', skin) || !uc.commit('modemskin'))
                    return { ok: false, error: 'commit_failed' };
                return { ok: true, skin: skin };
            }
        }
    }
};
