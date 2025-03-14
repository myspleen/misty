<!--
SPDX-FileCopyrightText: syuilo and misskey-project
SPDX-License-Identifier: AGPL-3.0-only
-->

<template>
<SearchMarker path="/settings/deck" :label="i18n.ts.deck" :keywords="['deck', 'ui']" icon="ti ti-columns">
	<div class="_gaps_m">
		<MkSwitch :modelValue="profilesSyncEnabled" @update:modelValue="changeProfilesSyncEnabled">{{ i18n.ts._deck.enableSyncBetweenDevicesForProfiles }}</MkSwitch>

		<MkSwitch v-model="useSimpleUiForNonRootPages">{{ i18n.ts._deck.useSimpleUiForNonRootPages }}</MkSwitch>

		<MkSwitch v-model="navWindow">{{ i18n.ts.defaultNavigationBehaviour }}: {{ i18n.ts.openInWindow }}</MkSwitch>

		<MkSwitch v-model="alwaysShowMainColumn">{{ i18n.ts._deck.alwaysShowMainColumn }}</MkSwitch>

		<MkRadios v-model="columnAlign">
			<template #label>{{ i18n.ts._deck.columnAlign }}</template>
			<option value="left">{{ i18n.ts.left }}</option>
			<option value="center">{{ i18n.ts.center }}</option>
		</MkRadios>
	</div>
</SearchMarker>
</template>

<script lang="ts" setup>
import { computed, ref } from 'vue';
import MkSwitch from '@/components/MkSwitch.vue';
import MkRadios from '@/components/MkRadios.vue';
import { i18n } from '@/i18n.js';
import { definePage } from '@/page.js';
import { prefer } from '@/preferences.js';

const navWindow = prefer.model('deck.navWindow');
const useSimpleUiForNonRootPages = prefer.model('deck.useSimpleUiForNonRootPages');
const alwaysShowMainColumn = prefer.model('deck.alwaysShowMainColumn');
const columnAlign = prefer.model('deck.columnAlign');

const profilesSyncEnabled = ref(prefer.isSyncEnabled('deck.profiles'));

function changeProfilesSyncEnabled(value: boolean) {
	if (value) {
		prefer.enableSync('deck.profiles').then((res) => {
			if (res == null) return;
			if (res.enabled) profilesSyncEnabled.value = true;
		});
	} else {
		prefer.disableSync('deck.profiles');
		profilesSyncEnabled.value = false;
	}
}

const headerActions = computed(() => []);

const headerTabs = computed(() => []);

definePage(() => ({
	title: i18n.ts.deck,
	icon: 'ti ti-columns',
}));
</script>
