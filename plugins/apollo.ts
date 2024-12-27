export default defineNuxtPlugin((nuxtApp) => {
  const supabase = useSupabaseClient();

  nuxtApp.hook("apollo:auth", async ({ client, token }) => {
    const session = (await supabase.auth.getSession()).data.session;
    if (session) {
      token.value = session.access_token;
    }
  });
});
