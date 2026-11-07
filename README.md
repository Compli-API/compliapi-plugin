# CompliAPI plugin for Claude Code

Real-time OFAC and global sanctions screening inside Claude Code. Bundles the hosted [CompliAPI MCP server](https://docs.compliapi.com/mcp) — eleven read-only tools that screen crypto wallet addresses (any chain, ENS names supported), emails, websites, government IDs, ships (IMO number or MMSI), aircraft (registration, serial number or Mode S code), and countries against the US OFAC SDN and Consolidated lists, the UN Security Council list plus 10+ global sanctions, crime, and risk lists; screen the names of people, companies, vessels and aircraft against sanctions-list names and aliases with a 0–100 score; screen person names against the OpenSanctions politically exposed persons (PEP) dataset; and provide VPN detection and IP geolocation.

## Install

```
/plugin marketplace add Compli-API/compliapi-plugin
/plugin install compliapi@compliapi
```

## Authentication

Works two ways — pick one:

**Free API token** (free tier: 1,000 requests/month, no credit card; Developer and Team plans 10,000 per seat) — create one at [app.compliapi.com](https://app.compliapi.com/account/signup), then either:

```bash
export COMPLIAPI_API_TOKEN=capi_...        # in your shell profile, or
mkdir -p ~/.compliapi && echo 'capi_...' > ~/.compliapi/token && chmod 600 ~/.compliapi/token
```

**No token** — listing tools always works anonymously; screening calls can be paid per request via [x402](https://docs.compliapi.com/payments) USDC micropayments with an x402-capable wallet — $0.01 per call on Base, except `screen_pep` at $0.05 (its upstream dataset is metered per query; the amount in the 402 challenge is always authoritative).

## Use

Ask naturally ("screen 0x7F36…e1B and compliance@example.com", "is the tanker IMO 9116412 sanctioned?") or invoke the workflow skill:

```
/compliapi:screen vitalik.eth
```

Every list-screening response reports `sanctioned` (a government sanctions-list hit), `flagged` (any hit, including crime/risk lists), and per-list matches with official source URLs. `screen_name` matches are fuzzy, each with a `score` (0–100) and `reasons` — a partial match is a lead to review, not a confirmed hit; pass `birth_date` and `country` to separate namesakes. `screen_pep` returns its own shape: scored candidates (`score` 0–1, `match` above the 0.7 threshold) and a top-level `pep` flag — PEP status is not a sanctions designation.

| Tool | Screens |
|---|---|
| `screen_crypto_address` | Wallets on any chain, ENS names |
| `screen_email` | Email addresses |
| `screen_website` | Websites and domains |
| `screen_government_id` | Passports, national IDs, tax IDs |
| `screen_name` | Names of people, companies, vessels and aircraft against sanctions-list names and aliases (OFAC, UN, EU, UK, SECO, Canada, Australia, Trésor, Japan MOF; scored; optional `type`, `birth_date`, `country`, `threshold`) |
| `screen_vessel` | Ships by IMO number or MMSI |
| `screen_aircraft` | Aircraft by registration (tail number), serial number or Mode S code |
| `screen_country` | Country sanctions designations |
| `screen_pep` | Person names against the OpenSanctions PEP dataset (scored matching; optional `birth_date`, `country`) |
| `detect_vpn` | VPN/proxy detection for an IP |
| `geolocate_ip` | IP geolocation + sanctioned-country flag |

## Links

- API docs: https://docs.compliapi.com
- Data sources & public datasets: https://compliapi.com/data-sources
- Support: help@compliapi.com

Results are list screenings, not legal advice.
