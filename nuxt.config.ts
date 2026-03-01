// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: [
    '@nuxt/eslint',
    '@nuxt/image',
    '@nuxt/ui',
    '@nuxt/content',
    '@vueuse/nuxt',
    'nuxt-og-image',
    'motion-v/nuxt',
    '@nuxtjs/i18n'
  ],

  devtools: {
    enabled: true
  },

  app: {
    baseURL: '/nuxt/'
  },

  compatibilityDate: '2024-11-01',

  // nitro: {
  //   prerender: {
  //     routes: [
  //       '/'
  //     ],
  //     crawlLinks: true
  //   }
  // },

  eslint: {
    config: {
      stylistic: {
        commaDangle: 'never',
        braceStyle: '1tbs'
      }
    }
  },

  fonts: {
    providers: {
      google: false,
      googleicons: false
    }
  },

  i18n: {
    locales: [
      { code: 'en', name: 'English', file: 'en.json' },
      { code: 'zh', name: '简体中文', file: 'zh.json' }
    ],
    defaultLocale: 'en',
    strategy: 'no_prefix',
    langDir: 'i18n/locales'
  }
})
