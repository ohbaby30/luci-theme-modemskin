/*!
 * ModemSkin navigation, based on hakureiyuyuko/luci-theme-ctmodem.
 * Licensed under the MIT License. See LICENSE.
 */
'use strict';
(function () {
	function label(node) { return node ? _(node.title || '') : ''; }
	function children(ui, node) {
		if (!node) return [];
		return ui.menu.getChildren(node).filter(function (n) { return n.name !== 'logout'; }).map(function (n) {
			// LuCI resolves aliases by substituting the target's children. A plugin
			// such as PassWall2 aliases its own landing page while declaring sibling
			// pages on the original branch. Keep those explicit navigation children.
			var source = node.children && node.children[n.name];
			var branch = source && source.children;
			var explicit = branch && branch !== n.children && Object.keys(branch).some(function (name) {
				return name !== 'logout' && branch[name].satisfied && Object.prototype.hasOwnProperty.call(branch[name], 'title');
			});
			return explicit ? Object.assign({}, n, { children: branch }) : n;
		});
	}
	function link(parts) { return L.url.apply(L, parts.filter(Boolean)); }
	function choose(nodes, name) {
		return nodes.find(function (n) { return n.name === name; }) || null;
	}
	function item(node, parts, active, current) {
		var li = document.createElement('li');
		li.className = active ? 'active' : '';
		var a = document.createElement('a');
		a.href = link(parts);
		a.setAttribute('data-ct-menu', node.name);
		var icon = document.createElement('span');
		icon.className = 'ct-nav-icon';
		icon.setAttribute('aria-hidden', 'true');
		a.appendChild(icon);
		a.appendChild(document.createTextNode(label(node)));
		if (current) a.setAttribute('aria-current', 'page');
		li.appendChild(a);
		return li;
	}
	function renderList(id, nodes, prefix, activeName, currentDepth, dp) {
		var ul = document.getElementById(id);
		if (!ul) return;
		var fragment = document.createDocumentFragment();
		var selected = null;
		ul.style.display = nodes.length ? '' : 'none';
		nodes.forEach(function (n) {
			var active = n.name === activeName;
			var li = item(n, prefix.concat(n.name), active, active && dp.length === currentDepth + 1);
			fragment.appendChild(li);
			if (active) selected = li;
		});
		ul.replaceChildren(fragment);
		if ((id === 'ont-tabbar' || id === 'topmenu') && selected)
			selected.scrollIntoView({ block: 'nearest', inline: 'nearest' });
	}
	function renderBranch(ui, ul, nodes, prefix, dp, depth) {
		nodes.forEach(function (n) {
			var parts = prefix.concat(n.name);
			var active = n.name === dp[depth];
			var li = item(n, parts, active, active && depth === dp.length - 1);
			ul.appendChild(li);
			var subnodes = active ? children(ui, n) : [];
			if (subnodes.length) {
				li.className += ' menu-branch';
				var sub = document.createElement('ul');
				li.appendChild(sub);
				renderBranch(ui, sub, subnodes, parts, dp, depth + 1);
			}
		});
	}
	function render(ui, tree) {
		var dp = L.env.dispatchpath || [];
		var modeName = dp[0] || (L.env.requestpath || [])[0] || 'admin';
		var mode = tree.children && tree.children[modeName];
		var l1 = children(ui, mode);
		var n1 = choose(l1, dp[1]) || l1[0];
		var l2 = children(ui, n1);
		var n2 = choose(l2, dp[2]);
		renderList('ct-shortcut-links', l1, [modeName], n1 && n1.name, 1, dp);
		var shortcutButton = document.getElementById('ct-shortcuts-open');
		if (shortcutButton) shortcutButton.disabled = !l1.length;
		renderList('topmenu', l1, [modeName], n1 && n1.name, 1, dp);
		renderList('ont-tabbar', l2, [modeName, n1 && n1.name], n2 && n2.name, 2, dp);
		var left = document.getElementById('leftmenu');
		if (left) {
			var fragment = document.createDocumentFragment();
			var l3 = children(ui, n2);
			left.style.display = l3.length ? '' : 'none';
			renderBranch(ui, fragment, l3, [modeName, n1 && n1.name, n2 && n2.name], dp, 3);
			left.replaceChildren(fragment);
		}
		var loc = document.getElementById('menuloc');
		if (loc) loc.textContent = label(n1) || document.title;
		var title = document.getElementById('lefttitle');
		if (title) title.textContent = label(n2);
		var modes = children(ui, tree);
		renderList('modemenu', modes.length > 1 ? modes : [], [], modeName, 0, dp);
		// Local CBI tab bars remain inside their own form, including modal forms.
		// They must never replace dispatcher navigation to sibling plugin pages.
	}
	function labelProgressBar(bar) {
			var fill = bar.firstElementChild;
			if (!fill || fill.nodeName !== 'DIV') return;
			var text = bar.getAttribute('title') || '';
			var span = fill.querySelector('span.ont-progress-label');
			if (!text) {
				if (span) span.remove();
				return;
			}
			if (!span) {
				span = document.createElement('span');
				span.className = 'ont-progress-label';
				fill.appendChild(span);
			}
			if (span.textContent !== text) span.textContent = text;
	}
	function watchProgressBars() {
		document.querySelectorAll('.cbi-progressbar').forEach(labelProgressBar);
		if (typeof MutationObserver === 'undefined') return;
		function collect(node, bars) {
			if (node.nodeType !== 1 || node.classList.contains('ont-progress-label')) return;
			if (node.classList.contains('cbi-progressbar')) bars.add(node);
			if (node.firstElementChild)
				node.querySelectorAll('.cbi-progressbar').forEach(function (bar) { bars.add(bar); });
		}
		new MutationObserver(function (records) {
			var bars = new Set();
			records.forEach(function (r) {
				if (r.type === 'attributes') {
					if (r.target.classList.contains('cbi-progressbar')) bars.add(r.target);
					return;
				}
				if (r.target.nodeType === 1 && r.target.classList.contains('ont-progress-label')) return;
				var owner = r.target.nodeType === 1 && r.target.closest('.cbi-progressbar');
				// Ignore our own label insertion. External fill replacement/removal
				// still needs relabelling even when only text nodes were added.
				var ownInsertion = !r.removedNodes.length && r.addedNodes.length && [].every.call(r.addedNodes, function (n) {
					return n.nodeType === 1 && n.classList.contains('ont-progress-label');
				});
				if (owner && !ownInsertion) bars.add(owner);
				r.addedNodes.forEach(function (n) { collect(n, bars); });
			});
			bars.forEach(function (bar) { if (bar.isConnected) labelProgressBar(bar); });
		}).observe(document.body, { childList: true, subtree: true, attributes: true, attributeFilter: ['title'] });
	}
	function boot() {
		if (!document.getElementById('topmenu')) return;
		watchProgressBars();
		L.require('ui').then(function (ui) {
			return ui.menu.load().then(function (tree) {
				if (!tree || !tree.children || !Object.keys(tree.children).length) {
					ui.menu.flushCache();
					throw new Error('Empty navigation tree');
				}
				render(ui, tree);
			});
		}).catch(function (e) {
			console.error('modemskin: menu failed', e);
			var left = document.getElementById('leftmenu');
			if (left) {
				left.style.display = '';
				var li = document.createElement('li');
				li.textContent = _('Unable to load the navigation menu. Please reload the page.');
				left.replaceChildren(li);
			}
		});
	}
	if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot);
	else boot();
})();
