# CreatorInc Demo Runbook

## 1. Demo goal

Show how CreatorInc connects two sides of the creator economy in one end-to-end story:

> A brand discovers creator content, publishes a paid opportunity, reviews interested creators, and starts a conversation. A creator presents their work, discovers the opportunity, expresses interest, saves it, and replies to the brand.

Target length: **10–12 minutes**. Use two test accounts and, ideally, two simulators or devices so the Brand and Creator views can be shown without repeated sign-in.

## 2. Actors

| Actor | What they want | Main areas to demonstrate |
|---|---|---|
| Creator | Present their profile and videos, find paid work, and speak to brands | Home feed, Creator Profile, Shorts, Discover, My Gigs, Messages |
| Brand | Find suitable creators, publish opportunities, review interest, and start outreach | Home feed, Brand Profile, Discover, My Gigs, Interested Creators, Messages |
| Platform | Connect both actors and persist the marketplace workflow | Authentication, role routing, profiles, shared feed, gig interest, chat |

## 3. Pre-demo setup

Complete these checks before presenting:

- Confirm Supabase configuration is available and both accounts can log in.
- Confirm Stream Chat configuration is available and both accounts connect successfully.
- Prepare one Creator account with a profile photo, bio, niche, and at least two uploaded Shorts.
- Prepare one Brand account with company name, intro, industries, website, location, and target creator niches.
- Create at least one open gig with a future closing date.
- Keep a short video under the permitted duration in the device photo library for the upload demonstration.
- Make sure the Creator has **not** already indicated interest in the featured gig, unless you plan to show the saved/disabled state.
- Keep both devices on a reliable network and disable disruptive notifications.
- Launch each account once before the demo to warm up media thumbnails, feed data, and chat connection.

### Suggested demo data

| Item | Suggested value |
|---|---|
| Creator | Jess Miller |
| Niche | Travel & Lifestyle |
| Creator bio | London-based creator making energetic travel and lifestyle videos for social-first campaigns. |
| Brand | NaturSun |
| Industries | Skincare, Wellness |
| Target niches | Beauty, Lifestyle |
| Gig title | Summer Skincare Launch |
| Budget | £1,500 |
| Brief | Create authentic short-form content introducing NaturSun's summer skincare range. |
| Requirements | UK based; lifestyle or beauty audience; confident on camera |
| Deliverables | 2 vertical videos; 3 story frames |
| Tags | Beauty, Lifestyle, UGC |

## 4. Recommended demo sequence

### Act 1 — Introduce the marketplace (30 seconds)

**Actor:** Platform

1. Open the welcome screen.
2. Point out the two account roles: **Creator** and **Brand**.
3. State the value proposition: creators showcase their work and discover paid gigs; brands discover talent and manage creator interest.

**Expected outcome:** The audience understands the two-sided marketplace before seeing individual screens.

### Act 2 — Creator builds a professional presence (2 minutes)

**Actor:** Creator

1. Log in with the prepared Creator account.
2. Show that Creator login routes to the Creator experience.
3. Open the profile from the Home toolbar.
4. Highlight the profile photo, display name, bio, niche, and social metric cards.
5. Tap **Edit** and briefly show photo selection, name, bio, and category controls; return without changing prepared data if time is tight.
6. In **Shorts**, open an existing Short to show playback.
7. Tap the upload control, select the prepared video, add a description, and upload it.
8. Mention that a Creator can long-press a Short and delete it with confirmation.

**Expected outcome:** The Creator has a rich, discoverable profile and a portfolio of playable short-form videos.

**Narration:** “A creator is more than a static profile. Their work is the portfolio, so brands can evaluate style and fit before making contact.”

### Act 3 — Creator discovers and saves an opportunity (2 minutes)

**Actor:** Creator

1. Open **Discover**.
2. Switch between the **Creators** and **Gigs** segments to show marketplace breadth.
3. Open the featured gig.
4. Highlight title, budget, status, brief, requirements, deliverables, tags, and closing date.
5. Tap **Indicate interest**.
6. Show the success state and explain that repeat interest is prevented.
7. Open **My Gigs** and show that the gig is now saved there.

**Expected outcome:** A single action converts discovery into a trackable opportunity for the Creator and a candidate signal for the Brand.

**Narration:** “Interest is lightweight for the creator, but immediately useful to the brand. The opportunity is also retained in My Gigs, so it is easy to revisit.”

### Act 4 — Brand discovers talent (2 minutes)

**Actor:** Brand

1. Switch to the prepared Brand account/device.
2. Show the Home feed and play one Creator Short.
3. Open **Discover**, select **Creators**, and open Jess Miller's creator card.
4. Highlight the creator's photo, niche, bio, and Shorts portfolio.
5. Tap the message icon to create/open a direct conversation.
6. Send: “Hi Jess — your style looks ideal for our summer skincare launch.”

**Expected outcome:** The Brand moves from content discovery to creator evaluation and direct outreach without leaving the app.

**Narration:** “The shared content feed creates discovery; the public creator profile supplies the evidence; direct messaging turns that interest into a relationship.”

### Act 5 — Brand publishes and manages a gig (2 minutes)

**Actor:** Brand

1. Open **My Gigs**.
2. Tap **New Gig**.
3. Show the structured fields: title, budget, brief, closing date, requirements, deliverables, and selectable tags.
4. Save the gig and point out that it appears immediately at the top of the Brand's list.
5. Open the featured gig.
6. Open **Interested Creators** and show the count and Creator cards.
7. Open Jess Miller's card to demonstrate candidate review and access to their portfolio.

**Expected outcome:** The Brand can create an opportunity and review its candidate pipeline from one place.

### Act 6 — Close the loop with messaging (1 minute)

**Actors:** Creator and Brand

1. Return to the Creator device and open **Messages**.
2. Open the NaturSun conversation.
3. Show the incoming message and reply: “Thanks — I’m interested and have just reviewed the brief.”
4. Return to the Brand conversation, if time permits, to show the response.

**Expected outcome:** The audience sees a complete cross-actor loop: discover → assess → express interest → shortlist → converse.

## 5. Feature checklist by actor

### Creator

| Feature | Demo action | Proof to show |
|---|---|---|
| Account creation | Choose Creator and register with email/password | Successful account-created message and login route |
| Login and role routing | Log in as Creator | Creator tabs: Home, Discover, My Gigs, Messages |
| Profile creation/editing | Add/change photo, name, bio, and category | Saved profile renders the updated information |
| Social metrics | Open Creator profile | Instagram, TikTok, and engagement cards are visible |
| Shorts portfolio | Select, describe, compress, thumbnail, and upload a video | New Short appears first in the profile grid |
| Short playback | Tap a Short | Video player opens |
| Short deletion | Long-press a Short and choose Delete | Confirmation appears and deleted Short leaves the grid |
| Shared feed | Scroll Home and play a Short | Paginated creator content loads and plays |
| Discover creators | Open a Creator result | Public profile, bio, niche, and Shorts appear |
| Discover gigs | Open a Gig result | Full brief, budget, requirements, deliverables, tags, and close date appear |
| Indicate interest | Tap the gig action | Success feedback appears and action becomes unavailable |
| Saved gigs | Open My Gigs | Interested gigs are listed and can be reopened |
| Messaging | Open Messages and send a reply | Message bubble appears in the conversation |
| Sign out | Tap the Home toolbar sign-out icon | User returns to Login |

### Brand

| Feature | Demo action | Proof to show |
|---|---|---|
| Account creation | Choose Brand and register with email/password | Successful account-created message and login route |
| Login and role routing | Log in as Brand | Brand tabs: Home, Discover, My Gigs, Messages |
| Brand profile | Add company name, intro, industries, website, niches, and location | Saved profile shows chips, link, and location |
| Brand profile editing | Tap Edit and change a field | Saved change appears on the profile |
| Shared feed | Scroll Home and play a Creator Short | Creator content loads and plays |
| Creator discovery | Open creator cards | Creator details and portfolio are visible |
| Direct outreach | Tap message on a Creator profile | Direct conversation opens |
| Gig discovery | Switch Discover to Gigs | Marketplace gigs are visible read-only |
| Create gig | Complete and save New Gig | New open gig appears at the top of My Gigs |
| Gig management | Open an owned gig | Full gig details and candidate panel appear |
| Interest count | View Interested Creators | Current number of interested Creators appears |
| Candidate review | Open an interested Creator | Public creator profile and Shorts are visible |
| Messaging | Open Messages and send a message | Conversation is retained in the channel list |
| Sign out | Tap the Home toolbar sign-out icon | User returns to Login |

## 6. What not to present as complete

Keep the demo accurate about the current build:

- Feed **Like**, **Comment**, and **Share** controls are visible but deliberately disabled.
- Google and Apple sign-in buttons are present in the account screen, but no action is currently wired to them.
- Creator social metrics are currently display values rather than live connected analytics.
- A Brand can create and inspect gigs, but editing, closing, deleting, creator selection, and formal campaign workflow are not exposed in the current UI.
- Messaging depends on successful Stream Chat configuration and connection.
- Feed media and application data depend on Supabase availability and network access.

If asked, position these as the next product layer rather than attempting to demonstrate them.

## 7. Recovery plan

| Problem | Recovery during demo |
|---|---|
| Login or backend is slow | Move to the already authenticated second device and explain role-based routing verbally |
| Feed thumbnails are loading | Continue to Discover or Profile, then return after the cache warms |
| Video upload takes too long | Show existing Shorts and explain the select → describe → validate/compress → upload flow |
| Interest was already submitted | Show the disabled state and the saved gig in My Gigs; use another prepared gig if the live action is essential |
| No interested creators appear | Use the Creator device to indicate interest, then reopen the Brand gig |
| Chat connection is delayed | Show the retained channel list and existing conversation; avoid creating a new channel live |
| Only one device is available | Demo Creator first, sign out, then Brand; keep credentials ready for fast switching |

## 8. Closing summary

End with the full value loop:

1. Creators build a visual portfolio.
2. Brands discover creators through their actual content.
3. Brands publish structured paid opportunities.
4. Creators express interest and track relevant gigs.
5. Brands review interested talent.
6. Both parties continue the relationship through direct messaging.

Suggested close: **“CreatorInc brings discovery, opportunity management, proof of work, and communication into one focused marketplace for creators and brands.”**
