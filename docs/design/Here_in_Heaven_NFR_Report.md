# Non-Functional Requirements (NFR) Report
## Here in Heaven — E-Commerce Storefront

---

## 1. Document Control

| Field | Value |
|---|---|
| Project Name | Here in Heaven |
| Document Version | v1.0 |
| Author | Yarelly Bustos |
| Date Created | 2026-08-09 |
| Last Updated | 2026-08-10 |
| Status | In Review |
| Related Documents | System Architecture Diagram, Database Schema, API Documentation |

---

## 2. Purpose & Scope

**Purpose:** This document defines the non-functional requirements (NFRs) for the Here in Heaven e-commerce storefront — the quality attributes the system must satisfy beyond its core features. These requirements guide technical decisions during design, development, and testing, and they give reviewers (technical or business) a measurable definition of "done" that goes beyond "the feature works."

**Scope:** This document covers the customer-facing storefront (browsing, cart, checkout) and the admin-facing management interface (product/order management). It does not define specific features — see the Functional Requirements / Product Backlog for that. It also does not define the database schema or API contracts — see those documents for structural detail.

**Intended audience:** Developer (self), store owner (business stakeholder), and technical reviewers (recruiters, mentors) evaluating engineering process.

---

## 3. Definitions

- **Functional Requirement (FR):** Describes *what* the system does (e.g., "a user can add a product to their cart").
- **Non-Functional Requirement (NFR):** Describes *how well* the system performs that function (e.g., "the cart updates in under 300ms"). NFRs are also called "quality attributes" or "system properties."
- **Metric:** A quantifiable way to measure whether an NFR is satisfied.
- **Target:** The specific threshold value the metric must meet.
- **Priority:** How critical the requirement is to launch, using the MoSCoW method (see Section 5).

This document loosely follows the **ISO/IEC 25010** software quality model, which organizes quality attributes into characteristics such as performance efficiency, reliability, security, usability, maintainability, and compatibility.

---

## 4. NFR Categories

### 4.1 Performance Efficiency

*How fast and resource-efficient the system is under normal use.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-PERF-01 | Product listing pages load quickly on typical mobile connections | First Contentful Paint under 2 seconds on simulated 4G | Must | Lighthouse audit in Chrome DevTools | Slow pages cause cart abandonment; most shoppers browse on mobile | Dev |
| NFR-PERF-02 | Checkout API responds quickly under normal (warm-server) conditions | Average response time under 1.5–2s across 10 manual test requests while the server is warm; first request after 15+ min idle may take up to ~60s due to free-tier cold start | Should | Manual timing test in Postman/Thunder Client — 10 requests while warm, averaged | 500ms at p95 assumes always-on paid infrastructure, which isn't in scope at launch | Dev |
| NFR-PERF-03 | Cart and checkout actions reflect instantly in the UI without a full page reload | UI updates within ~150ms of action; DevTools Network tab shows no full document reload | Must | Manual test in DevTools Network tab | Reload-based carts feel outdated and increase abandonment | Dev |
| NFR-PERF-04 | Product images are optimized for quick loading | Images served via Cloudinary `f_auto,q_auto`; average payload under ~150–200KB per product card | Should | Inspect Network tab image sizes; confirm transformation params in URL | Unoptimized images are the #1 cause of slow e-commerce pages | Dev |

### 4.2 Scalability

*How the system behaves as traffic or data volume grows.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-SCALE-01 | The system remains responsive during a marketing-driven traffic spike (e.g., a new drop announcement) | Handles at least 10–15 concurrent users without error rate exceeding 5% | Could | Load test using k6 or Artillery once basic load-testing tutorial is completed | Merch drops create bursty traffic; a crash during launch directly costs sales | Dev |
| NFR-SCALE-02 | Product catalog structure (database schema) supports growth well beyond the current catalog size without requiring redesign | Schema supports 500+ products and unlimited categories with no structural migration needed | Must | Schema design review — confirm FK-based categories/variants, not hardcoded columns | Redesigning post-launch means downtime and migration risk | Dev |

### 4.3 Security

*How the system protects data and restricts access appropriately.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-SEC-01 | Raw credit card numbers never touch our backend or database | 100% of payment data handled via Stripe.js/Stripe Elements (tokenized) | Must | Code review; confirm no card fields are custom-built | Avoids PCI-DSS scope entirely by delegating to Stripe; storing raw card data would be a major liability | Dev |
| NFR-SEC-02 | Admin routes are inaccessible without a valid authenticated session | JWT required on all `/admin/*` and product-mutation endpoints; requests without a valid token return 401 | Must | Postman test suite hitting protected routes with/without token | Prevents anyone from editing products or viewing orders without logging in | Dev |
| NFR-SEC-03 | User passwords are never stored in plain text | Passwords hashed with bcrypt (cost factor ≥ 10) before storage | Must | Database inspection; code review | Plain-text password storage is a critical, well-known vulnerability | Dev |
| NFR-SEC-04 | All customer data is transmitted over HTTPS | 100% of traffic over TLS; HTTP auto-redirects to HTTPS | Must | Check padlock icon + confirm host platform enforces redirect | Unencrypted traffic exposes customer data in transit | Dev |

### 4.4 Reliability & Availability

*How consistently the system stays up and recovers from failure.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-REL-01 | The storefront is available for customers during normal business hours | Target ~95% uptime, accounting for free-tier cold starts; a scheduled keep-alive ping (e.g., cron-job.org hitting a `/health` endpoint every ~10 min) is used to reduce spin-downs | Should | Uptime monitor (e.g., UptimeRobot free tier) | The site is a real revenue channel for the business; free-tier hosting sleeps after ~15 min idle, so 99% is not achievable without paid infrastructure | Dev |
| NFR-REL-02 | A failed payment does not create a "ghost" order in the database | Orders are only marked "confirmed" after Stripe webhook confirms payment success | Must | Manual test: decline a test card and confirm no order record is created | Prevents inventory/records being corrupted by incomplete transactions | Dev |
| NFR-REL-03 | Checkout and payment flow fail gracefully, displaying a clear error | On Stripe timeout/error, user sees a specific error message; cart stays intact | Must | Manual test using Stripe's test failure cards | A broken checkout with a lost cart loses the sale permanently | Dev |
| NFR-REL-04 | Cart content persists if a user refreshes the page or loses connection | Cart survives a full page refresh and a ~30s connection drop | Should | Manual test: add items, refresh, confirm cart remains intact | Refresh-wiped carts frustrate customers into leaving | Dev |

### 4.5 Usability & Accessibility

*How easily real users (including those with disabilities) can use the system.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-USE-01 | The storefront is fully usable on mobile devices | All pages pass a manual responsive check at 375px, 768px, and 1440px widths | Must | Manual test in browser dev tools + real device | Majority of apparel shoppers browse and buy on mobile | Dev |
| NFR-USE-02 | Product images have descriptive alt text | 100% of product images include alt attributes describing the product | Should | Automated accessibility scan (e.g., axe DevTools) | Supports screen-reader users and improves SEO | Dev |
| NFR-USE-03 | Text and buttons meet basic color contrast standards | All text/button pairs meet WCAG AA (4.5:1 for normal text) | Should | WebAIM contrast checker on brand colors | Poor contrast excludes visually impaired users; easy fix | Dev |
| NFR-USE-04 | Forms show clear inline error messages instead of generic failures | 100% of invalid fields show a specific message, not a generic alert | Must | Manual test submitting bad checkout/contact data | Generic errors leave shoppers stuck mid-checkout | Dev |
| NFR-USE-05 | Site navigation and category filtering allow customers to reach any product with minimal clicking | Any product reachable in ≤3 clicks from the homepage | Should | Manual click-path audit per category | Deep navigation increases bounce rate on a small catalog | Dev |

### 4.6 Maintainability

*How easily the system can be understood, modified, and extended.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-MAINT-01 | Codebase follows a consistent folder structure separating routes, controllers, and models | 100% of backend code organized by this convention | Should | Code review | Makes the codebase easier to extend and easier for a recruiter/reviewer to navigate | Dev |
| NFR-MAINT-02 | Environment-specific values (API keys, DB credentials) are never hardcoded | 100% of secrets loaded via `.env` and excluded from Git via `.gitignore` | Must | Code review; check Git history for leaked secrets | Hardcoded secrets are a security risk and break across environments (dev/prod) | Dev |
| NFR-MAINT-03 | Adding a new product, category, or size option is manageable through the admin interface | 100% of catalog changes done via admin UI, no code edits/redeploys | Must | Add a new category/product entirely through admin, confirm no code touched | This is the entire reason the admin panel exists | Dev |

### 4.7 Compatibility & Portability

*How well the system works across browsers, devices, and environments.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-COMPAT-01 | The storefront renders correctly on major browsers | Verified on latest Chrome, Safari, and Firefox | Should | Manual cross-browser test | Customers use varied browsers; Safari especially matters for iPhone shoppers | Dev |
| NFR-COMPAT-02 | The store functions correctly on mobile-native browsers, not just desktop browsers resized smaller | Verified functional on Safari iOS and Chrome Android for browse, cart, and checkout | Must | Manual test on real devices | Mobile-specific bugs would not be caught using desktop-only testing | Dev |

### 4.8 Compliance

*Legal, regulatory, or industry-standard obligations.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-COMP-01 | Payment processing meets PCI-DSS requirements by design | Achieved by using Stripe Checkout/Elements exclusively (no self-managed card data) | Must | Architecture review | Avoids the business needing to self-certify PCI compliance | Dev |

### 4.9 Observability

*How easily the system's internal behavior can be monitored and debugged.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-OBS-01 | Backend errors are logged with enough context to debug without reproducing locally | All 4xx/5xx responses logged with route, timestamp, and error message | Should | Manual review of server logs | Speeds up debugging production issues without local reproduction | Dev |

### 4.10 Data Privacy & Compliance

*How customer data is collected, used, and protected in accordance with privacy expectations and regulations.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-DPC-01 | Customer personal data is only used for order fulfillment and is never sold to third parties without explicit consent | No third-party sharing beyond required processors; stated in policy | Should | Architecture review; policy text review | Builds trust between the business and customers while also protecting the business legally | Dev |
| NFR-DPC-02 | Includes a basic privacy policy disclosing what data is collected and why | Policy page linked in footer, includes what is collected and why | Should | Manual review of policy page content | Discloses data practices upfront, reducing legal risk and building customer trust | Dev |
| NFR-DPC-03 | Customers can request their data be deleted, even if handled manually via email to start | 100% of deletion requests acknowledged within 5 business days; data removed from the database within 30 days of request | Could | Manual test: submit a deletion request via the contact email and confirm the customer record is removed from the database | Gives customers a baseline data-deletion right even without a self-service account portal; builds trust and aligns with common privacy expectations | Store Owner (handles request) + Dev (performs deletion) |

### 4.11 Auditability

*How traceable system actions are for accountability and troubleshooting.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-AUD-01 | Admin actions are logged with a timestamp and admin identity for traceability | Product/order admin actions produce a confirmed log entry | Could | Trigger an admin action, confirm log entry is created | Provides a paper trail if a pricing mistake occurs | Dev |

### 4.12 Backup & Disaster Recovery

*How the system protects against and recovers from data loss or catastrophic failure.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-BDR-01 | Database is backed up on a regular schedule with a documented restore procedure | Database is backed up weekly via manual export (e.g., `mysqldump`/`pg_dump`) stored outside the host; if using a free-tier database, it is upgraded to paid or migrated before any free-tier expiration deadline to avoid permanent data loss | Must | Confirm backup exists outside the host, complete one test restore | Free-tier databases can auto-delete after a fixed period with no recovery — this is a hard deadline, not a best-practice suggestion | Dev |
| NFR-BDR-02 | A rollback plan exists for failed deployments | Revert to last working deploy within 10–15 minutes, accounting for redeploy build time and potential cold start | Should | Practice a rollback on a staging deploy and time the full process | Prevents extended downtime in case of a bug | Dev |

### 4.13 Rate Limiting / Brute-Force Protection

*How the system defends against automated abuse and credential attacks.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-RLBF-01 | Login and checkout endpoints enforce rate limiting to prevent brute-force and credential-stuffing attacks | Max 5 login attempts per IP per 10 minutes, then returns 429 | Should | Script hitting login repeatedly, confirm 429 response | Provides a cheap, effective defense against brute-force attacks | Dev |

### 4.14 Third-Party Dependency Resilience

*How gracefully the system handles failures in external services it depends on.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-TPDR-01 | If Cloudinary is unreachable, the product page shows a placeholder image instead of a broken layout | Broken image URL falls back to a placeholder with no layout break | Could | Manual test with an invalid image URL | Prevents a third-party outage from breaking the whole page | Dev |
| NFR-TPDR-02 | If the order confirmation email fails to send, the on-screen confirmation still displays and the failure is logged for manual follow-up | Order success page shows regardless of email-send status | Should | Simulate an email API failure, confirm order still completes | Decouples the critical path (order) from a non-critical side effect (email) | Dev |

### 4.15 Session & Token Management

*How user authentication sessions are issued, expired, and invalidated securely.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-STM-01 | JWTs expire after a defined window and require re-authentication after expiry, with shorter expiry for admin sessions | Customer tokens expire within 24 hours; admin tokens expire within 2 hours, both requiring re-login after expiry | Must | Code review of `expiresIn` config | Long-lived tokens are a risk if leaked or a device is lost; admin tokens carry higher risk and get a tighter window | Dev |
| NFR-STM-02 | Expired or tampered tokens are rejected with a clear 401 | Expired/tampered tokens always return 401, never 500 | Must | Postman tests with expired/malformed/missing tokens | Inconsistent handling can accidentally expose protected data | Dev |

### 4.16 Data Integrity

*How accurately and consistently critical data (orders, inventory, payments) is maintained.*

| ID | Requirement | Metric / Target | Priority | Verification Method | Rationale | Owner |
|---|---|---|---|---|---|---|
| NFR-DI-01 | Inventory stock levels update correctly and cannot be oversold when multiple customers attempt to purchase the same item simultaneously | Stock decrements atomically at order confirmation; a last-unit race condition never double-sells | Must | Simulate two near-simultaneous purchases of the last unit | Overselling forces refunds and damages trust; implemented via SQL row-locking (`SELECT ... FOR UPDATE`) inside the order transaction | Dev |
| NFR-DI-02 | Order records in the database always reflect the exact amount actually charged through Stripe | Every order's charged amount matches its Stripe payment amount, 100% of the time | Must | Spot-check orders against Stripe dashboard records | A mismatch means overcharging or losing revenue — direct financial risk | Dev |

---

## 5. Prioritization Key (MoSCoW)

| Level | Meaning |
|---|---|
| **Must** | Required for launch; the store cannot go live without this |
| **Should** | Important, but the store can launch without it and add it shortly after |
| **Could** | Nice to have; add if time and scope allow |
| **Won't** | Explicitly out of scope for this version |

---

## 6. Assumptions & Constraints

- Solo developer project — no dedicated QA, security, or DevOps team.
- Hosting initially on free/low-cost tiers (Vercel, Railway/Render), which affects uptime and scalability targets.
- Backend hosted on a free tier that spins down after ~15 minutes of inactivity; the first request after idle may take up to ~60 seconds (cold start). A keep-alive ping reduces this but does not eliminate it.
- Payment processing is delegated entirely to Stripe to avoid PCI-DSS compliance burden.
- Traffic volume is expected to be small-to-moderate (a real small business, not high-scale enterprise), so scalability targets are set realistically rather than aspirationally.

---

## 7. Review & Sign-off

| Role | Name | Date | Approved (Y/N) |
|---|---|---|---|
| Developer | | | |
| Business Stakeholder (Store Owner) | | | |

---

## 8. Revision History

| Version | Date | Author | Change Summary |
|---|---|---|---|
| v0.1 | 2026-08-09 | Yarelly Bustos | Initial draft template |
| v1.0 | 2026-08-10 | Yarelly Bustos | All categories fully populated; metrics revised for free-tier hosting realism; template scaffolding removed |
