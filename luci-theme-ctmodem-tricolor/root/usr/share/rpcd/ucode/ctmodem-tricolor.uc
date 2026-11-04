// CTModem Tricolor: fixed-purpose appearance save; no general UCI commit API.
// MIT License.
'use strict';
import { cursor } from 'uci';

return {
    'ctmodem.tricolor': {
        save: {
            args: { skin: '' },
            call: function(request) {
                const skin = request.args.skin;
                if (skin != 'telecom' && skin != 'unicom' && skin != 'mobile')
                    return { ok: false, error: 'invalid_skin' };

                // Absolute-path loading deliberately bypasses UCI delta overlays.
                // Only the committed file is read and updated, not CLI/session edits.
                const uc = cursor();
                if (!uc.load('/etc/config/ctmodem_tricolor'))
                    return { ok: false, error: 'config_unavailable' };
                if (!uc.get('ctmodem_tricolor', 'main'))
                    uc.set('ctmodem_tricolor', 'main', 'appearance');
                if (!uc.set('ctmodem_tricolor', 'main', 'skin', skin) || !uc.commit('ctmodem_tricolor'))
                    return { ok: false, error: 'commit_failed' };
                return { ok: true, skin: skin };
            }
        }
    }
};
