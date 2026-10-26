---
description: Screen a counterparty (crypto wallet, email, website/domain, government ID, or country) against OFAC and global sanctions lists, or a person's name against the OpenSanctions politically exposed persons (PEP) dataset, using the CompliAPI tools. Use when the user asks to screen, sanction-check, OFAC-check, PEP-check, or vet a wallet address, customer, person, email, domain, ID, or country — or to check an IP for VPN use or sanctioned-country geolocation.
---

# Screen a counterparty

Screen whatever identifiers the user provides using the CompliAPI MCP tools, then report the compliance picture in one place.

## Workflow

1. Collect every identifier mentioned: wallet addresses (any chain — EVM, Bitcoin, Tron, Solana; ENS names like `name.eth` resolve automatically), email addresses, websites/domains, government-issued IDs, countries, IP addresses, and person names (for PEP checks — note any birth date or country given alongside).
2. Call the matching tool for each, in parallel where possible:
   - `screen_crypto_address` — wallets and ENS names
   - `screen_email` — email addresses
   - `screen_website` — websites or bare domains
   - `screen_government_id` — passports, national IDs, tax IDs (similarity-ranked matching)
   - `screen_country` — country names or ISO codes (sanctions designations, e.g. comprehensive embargoes)
   - `screen_pep` — a person's full name (`name`, 2–200 characters) against the OpenSanctions PEP dataset; pass `birth_date` (`YYYY-MM-DD` or partial, e.g. `1961`) and `country` (name or ISO code) whenever known — they sharpen matching
   - `detect_vpn` / `geolocate_ip` — IP trust and sanctioned-country flags
3. Interpret each response precisely — the two flags mean different things:
   - `sanctioned: true` — a **government sanctions list** matched (OFAC SDN, OFAC Consolidated, EU, UK, France, Japan, Israel). Treat as a hard stop.
   - `flagged: true` with `sanctioned: false` — a **crime or risk list** matched (e.g. ransomware payment addresses, Tornado Cash association). Exposure signal, not a designation; say so explicitly.
   - Both false — no match on the lists checked (name the lists from `lists_checked`).
   - `screen_pep` uses a different envelope: `pep: true` means at least one candidate cleared the 0.7 score threshold (`matches[].match`); lower-scored candidates are listed for review but are not hits. PEP status is a due-diligence signal (current/former public officials, relatives, close associates), **not** a sanctions designation — never report it as `sanctioned`. To sanctions-screen the same person, use the other tools on their identifiers.
4. Report per identifier: verdict, which list(s) matched (`matches[].list_name`), match type (exact/partial), and the official `source_url` for every hit so the user can verify against the primary source. For PEP results, report the candidate's `caption`, `score`, `positions`, and `countries`, and the OpenSanctions `source_url`. Never soften or omit a sanctions hit.

## Auth and payment

Tools work with a CompliAPI API token (free tier: 1,000 requests/month, paid plans 10,000 per seat — set `COMPLIAPI_API_TOKEN` or `~/.compliapi/token`, see the plugin README) or anonymously via x402 USDC pay-per-call ($0.01 on Base for every tool except `screen_pep`, which costs $0.05 because its upstream dataset is metered per query — the amount in the payment challenge is always authoritative). If a tool call returns a 402/payment-required error result, tell the user their options: create a free token at https://app.compliapi.com/account/signup, or pay per call with an x402-capable wallet. Do not retry the call unchanged.

## Boundaries

Results are list screenings, not legal advice — for a hit, recommend the user verify via the source URL and follow their compliance program. Screening is typo-exact for most entity types (government IDs get similarity ranking; `screen_pep` uses scored name matching); do not claim fuzzy matching beyond that.
