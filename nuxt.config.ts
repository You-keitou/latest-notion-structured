// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  modules: [
    "@nuxtjs/supabase",
    "@nuxt/icon",
    "@nuxt/ui",
    "@nuxthub/core",
    "dayjs-nuxt",
    "@nuxtjs/apollo",
  ],
  colorMode: {
    preference: "system",
    fallback: "light",
  },
  apollo: {
    clients: {
      default: {
        httpEndpoint: `${process.env.SUPABASE_URL}/graphql/v1`,
        httpLinkOptions: {
          headers: {
            'apiKey': `${process.env.SUPABASE_KEY}`,
          },
        }
      },
    },
  },
});
