/* ModemSkin appearance control. MIT. */
'use strict';
(function () {
	function boot() {
		var select = document.getElementById('ct-skin-select');
		if (!select) return;
		var root = document.documentElement;
		var save = document.getElementById('ct-skin-save');
		var revert = document.getElementById('ct-skin-revert');
		var status = document.getElementById('ct-skin-status');
		var stylesheet = document.getElementById('ct-skin-style');
		var saved = root.getAttribute('data-ct-skin');
		var current = saved;
		var loading = false, saving = false, permitted = false;
		var rpc;
		function update() {
			select.value = current;
			select.disabled = loading || saving;
			save.disabled = loading || saving || !permitted || current === saved;
			revert.disabled = loading || saving || current === saved;
		}
		function message(text, error) {
			status.textContent = text;
			status.classList.toggle('ct-error', !!error);
		}
		function preview(skin) {
			if (loading || saving || ['telecom', 'unicom', 'mobile'].indexOf(skin) < 0) return;
			if (skin === current) { update(); return; }
			loading = true;
			update();
			message('正在加载外观…');
			var next = document.createElement('link');
			var url = new URL(stylesheet.href);
			url.pathname = url.pathname.replace(/\/(telecom|unicom|mobile)\.css$/, '/' + skin + '.css');
			next.rel = 'stylesheet';
			next.href = url.href;
			function finish(success) {
				clearTimeout(timer);
				next.onload = next.onerror = null;
				loading = false;
				if (success) {
					root.setAttribute('data-ct-skin', skin);
					stylesheet.remove();
					next.id = 'ct-skin-style';
					stylesheet = next;
					current = skin;
					message(current === saved ? '' : '预览中，尚未保存');
				} else {
					next.remove();
					message('外观加载失败，已保留原外观。', true);
				}
				update();
			}
			// All carrier rules are scoped to data-ct-skin. The new sheet can load
			// without changing the active layout, then swap in one synchronous step.
			next.onload = function () { finish(true); };
			next.onerror = function () { finish(false); };
			var timer = setTimeout(function () { finish(false); }, 15000);
			document.head.appendChild(next);
		}
		select.addEventListener('change', function () { preview(select.value); });
		revert.addEventListener('click', function () { preview(saved); });
		save.addEventListener('click', function () {
			if (!rpc || !permitted || loading || saving || current === saved) return;
			saving = true;
			update();
			message('正在保存外观…');
			// This RPC only accepts a whitelisted skin and commits one fixed config.
			// It never enters the shared UCI form state or calls uci.apply.
			rpc(current).then(function (result) {
				if (!result || result.ok !== true || result.skin !== current)
					throw new Error('Appearance configuration could not be saved');
				saved = current;
				message('外观已保存');
			}).catch(function (error) {
				console.warn('modemskin: appearance save failed', error.message || 'RPC failed');
				message('保存未确认，请重新登录或刷新检查；当前仍为预览。', true);
			}).finally(function () { saving = false; update(); });
		});
		update();
		L.require('rpc').then(function (api) {
			rpc = api.declare({ object: 'modemskin', method: 'save', params: ['skin'], expect: { '': {} }, reject: true });
			var access = api.declare({ object: 'session', method: 'access', params: ['scope', 'object', 'function'], expect: { access: false }, reject: true });
			return access('ubus', 'modemskin', 'save');
		}).then(function (access) {
			permitted = access === true;
			if (!permitted) message('可预览；当前账号无外观保存权限。');
			update();
		}).catch(function () { message('可预览；保存权限检查失败，请重新登录。', true); update(); });
		var dialog = document.getElementById('ct-shortcuts');
		var open = document.getElementById('ct-shortcuts-open');
		var close = document.getElementById('ct-shortcuts-close');
		if (dialog && open && close) {
			open.addEventListener('click', function () { if (!dialog.open) dialog.showModal(); });
			close.addEventListener('click', function () { dialog.close(); });
		}
	}
	if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot);
	else boot();
})();
