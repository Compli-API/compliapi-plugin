---
description: Screen a counterparty (crypto wallet, email, website/domain, government ID, or country) against OFAC and global sanctions lists using the CompliAPI tools. Use when the user asks to screen, sanction-check, OFAC-check, or vet a wallet address, customer, email, domain, ID, or country — or to check an IP for VPN use or sanctioned-country geolocation.
---

# Screen a counterparty

Screen whatever identifiers the user provides using the CompliAPI MCP tools, then report the compliance picture in one place.

## Workflow

1. Collect every identifier mentioned: wallet addresses (any chain — EVM, Bitcoin, Tron, Solana; ENS names like `name.eth` resolve automatically), email addresses, websites/domains, government-issued IDs, countries, and IP addresses.
2. Call the matching tool for each, in parallel where possible:
   - `screen_crypto_address` — wallets and ENS names
   - `screen_email` — email addresses
   - `screen_website` — websites or bare domains
   - `screen_government_id` — passports, national IDs, tax IDs (similarity-ranked matching)
   - `screen_country` — country names or ISO codes (sanctions designations, e.g. comprehensive embargoes)
   - `detect_vpn` / `geolocate_ip` — IP trust and sanctioned-country flags
3. Interpret each response precisely — the two flags mean different things:
   - `sanctioned: true` — a **government sanctions list** matched (OFAC SDN, OFAC Consolidated, EU, UK, France, Japan, Israel). Treat as a hard stop.
   - `flagged: true` with `sanctioned: false` — a **crime or risk list** matched (e.g. ransomware payment addresses, Tornado Cash association). Exposure signal, not a designation; say so explicitly.
   - Both false — no match on the lists checked (name the lists from `lists_checked`).
4. Report per identifier: verdict, which list(s) matched (`matches[].list_name`), match type (exact/partial), and the official `source_url` for every hit so the user can verify against the primary source. Never soften or omit a sanctions hit.

## Auth and payment

Tools work with a CompliAPI API token (free tier: 10,000 requests/month — set `COMPLIAPI_API_TOKEN` or `~/.compliapi/token`, see the plugin README) or anonymously via x402 USDC pay-per-call ($0.01 on Base). If a tool call returns a 402/payment-required error result, tell the user their options: create a free token at https://app.compliapi.com/account/signup, or pay per call with an x402-capable wallet. Do not retry the call unchanged.

## Boundaries

Results are list screenings, not legal advice — for a hit, recommend the user verify via the source URL and follow their compliance program. Screening is typo-exact for most entity types (government IDs get similarity ranking); do not claim fuzzy matching beyond that.
