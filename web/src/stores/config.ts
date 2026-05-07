import { defineStore } from 'pinia';
import { OCCTLApi, SystemApi } from '@/api';
import type { ConfigState, ServerState } from '@/types/storeTypes/StoreConfigType';

export const useServerStore = defineStore('server', {
    state: (): ServerState => ({
        OcservVersion: '',
        OcctlVersion: '',
        Status: ''
    }),
    actions: {
        async getServerInfo() {
            const api = new OCCTLApi();
            await api
                .occtlServerInfoGet()
                .then((res) => {
                    if (res.data) {
                        this.OcservVersion = res.data.version.ocserv_version || '';
                        this.OcctlVersion = (res.data.version.occtl_version || '').replace(/\n/g, '<br />');
                    }
                })
                .catch(() => {});
        },
        async setStatus(status: string) {
            this.Status = status;
        }
    },
    getters: {
        getOcservVersion: (state) => state.OcservVersion,
        getOcctlVersion: (state) => state.OcctlVersion,
        getStatus: (state) => state.Status
    }
});

export const useConfigStore = defineStore('config', {
    state: (): ConfigState => ({
        setup: false,
        googleCaptchaSiteKey: ''
    }),

    actions: {
        async getConfig() {
            const api = new SystemApi();
            await api.systemInitGet().then((res) => {
                if (res.data) {
                    this.googleCaptchaSiteKey = res.data.google_captcha_site_key || '';
                    this.setup = true;
                }
            });
            return this.setup;
        },
        setConfig(googleCaptchaSiteKey: string | undefined) {
            if (googleCaptchaSiteKey) {
                this.googleCaptchaSiteKey = googleCaptchaSiteKey;
            }
            this.setup = true;
        }
    },
    getters: {
        config(state): ConfigState {
            return {
                setup: state.setup,
                googleCaptchaSiteKey: state.googleCaptchaSiteKey
            };
        }
    }
});
