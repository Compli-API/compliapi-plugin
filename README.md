# CompliAPI plugin for Claude Code

Real-time OFAC and global sanctions screening inside Claude Code. Bundles the hosted [CompliAPI MCP server](https://docs.compliapi.com/mcp) — seven read-only tools that screen crypto wallet addresses (any chain, ENS names supported), emails, websites, government IDs, and countries against the US OFAC SDN and Consolidated lists plus 10+ global sanctions, crime, and risk lists, with VPN detection and IP geolocation.

## Install

```
/plugin marketplace add Compli-API/compliapi-plugin
/plugin install compliapi@compliapi
```

## Authentication

Works two ways — pick one:

**Free API token** (10,000 requests/month) — create one at [app.compliapi.com](https://app.compliapi.com/account/signup), then either:

```bash
export COMPLIAPI_API_TOKEN=capi_...        # in your shell profile, or
mkdir -p ~/.compliapi && echo 'capi_...' > ~/.compliapi/token && chmod 600 ~/.compliapi/token
```

**No token** — listing tools always works anonymously; screening calls can be paid per request via [x402](https://docs.compliapi.com/payments) USDC micropayments ($0.01 on Base) with an x402-capable wallet.

## Use

Ask naturally ("screen 0x7F36…e1B and compliance@example.com") or invoke the workflow skill:

```
/compliapi:screen vitalik.eth
```

Every screening response reports `sanctioned` (a government sanctions-list hit), `flagged` (any hit, including crime/risk lists), and per-list matches with official source URLs.

| Tool | Screens |
|---|---|
| `screen_crypto_address` | Wallets on any chain, ENS names |
| `screen_email` | Email addresses |
| `screen_website` | Websites and domains |
| `screen_government_id` | Passports, national IDs, tax IDs |
| `screen_country` | Country sanctions designations |
| `detect_vpn` | VPN/proxy detection for an IP |
| `geolocate_ip` | IP geolocation + sanctioned-country flag |

## Links

- API docs: https://docs.compliapi.com
- Data sources & public datasets: https://compliapi.com/data-sources
- Support: help@compliapi.com

Results are list screenings, not legal advice.
