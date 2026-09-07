// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";




// This endpoint uses 'publishable' | 'secret' access, apiKey is required.
// Use publishable for Client-facing, key-validated endpoints
// Use secret for Server-to-server, internal calls
export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {

    // Get the Phyllo API key and secret from environment variables
    const clientId = Deno.env.get("PHYLLO_CLIENT_ID");
    const clientSecret = Deno.env.get("PHYLLO_CLIENT_SECRET");
    const baseUrl = Deno.env.get("PHYLLO_BASE_URL");

    if(!clientId || !clientSecret || !baseUrl) {
      throw new Error("Phyllo credentials not configured")
    } 
    if (!ctx.userClaims){
      throw new Error ("No authenticated User")
    }
    
    const userId = ctx.userClaims.id;

    const{ data } =await ctx.supabase.from("creator_phyllo_links").select("phyllo_user_id").eq("creator_user_id", userId).maybeSingle();
    const link = data as { phyllo_user_id: string } | null;
    // let phylloUserId: string | null
    // let phylloUserId = link?.phyllo_user_id ?? null;
    let phylloUserId: string | null;
    if(link){
      phylloUserId = link.phyllo_user_id
    } else {
      phylloUserId = null
    }

    if(!phylloUserId){
        //btoa for base64 encoding
        const basicAuth = "Basic " + btoa(`${clientId}:${clientSecret}`);
        const { data } = await ctx.supabase.from("creator_profiles").select("display_name").eq("user_id", userId).single();
        const profile = data as { display_name: string } | null;
        const res = await fetch(`${baseUrl}/v1/users`, {method: "POST", 
        headers: { "Content-Type": "application/json", "Authorization": basicAuth },
        body: JSON.stringify({name: profile?.display_name, external_id: userId}),
        });
        if(!res.ok){
          throw new Error(`failed ${await res.text()}`);
        }
    }




  }),
};
