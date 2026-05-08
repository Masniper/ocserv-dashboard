<script lang="ts" setup>
import { RouterView } from 'vue-router';
import MainView from './Main.vue';
import { useServerStore } from '@/stores/config';
import { useI18n } from 'vue-i18n';
import { computed } from 'vue';

const { t } = useI18n();

const serverStore = useServerStore();
const release = computed(() => serverStore.getDashboardRelease);
</script>

<template>
    <v-locale-provider>
        <v-app>
            <MainView />
            <v-main class="page-bg">
                <v-container class="page-wrapper" fluid>
                    <div class="maxWidth">
                        <RouterView />
                    </div>
                </v-container>
            </v-main>
        </v-app>
    </v-locale-provider>
</template>

<style lang="scss" scoped>
.page-bg {
    background-color: rgb(var(--v-theme-background));
    min-height: 100vh;
}
</style>
