// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";
import {StreamChat} from "stream-chat";

console.log("Hello from Functions!");

// This endpoint uses 'publishable' | 'secret' access, apiKey is required.
// Use publishable for Client-facing, key-validated endpoints
// Use secret for Server-to-server, internal calls
export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    
    // Get the Stream API key and secret from environment variables
    //supabase functions secrets set STREAM_API_KEY=your_stream_api_key
    const streamApiKey = Deno.env.get("STREAM_API_KEY");
    const streamApiSecret = Deno.env.get("STREAM_API_SECRET");
    if(!streamApiKey || !streamApiSecret) {
      throw new Error("Stream credentials not configured")
    } 
    if (!ctx.userClaims){
      throw new Error ("No authenticated User")
    }
    
    const userId = ctx.userClaims.id;
    const serverClient = StreamChat.getInstance(streamApiKey, streamApiSecret);
    const token = serverClient.createToken(userId);

    return Response.json({token})
    

  }),
};

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/stream-token' \
    --header 'apiKey: sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH' \
    --data '{"name":"Functions"}'

*/
