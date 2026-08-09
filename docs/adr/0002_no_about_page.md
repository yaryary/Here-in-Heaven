ADR 0002: Do Not Add an About Page in MVP

Status
Accepted — August 9, 2026

Context
The Current Store Audit Report (v1.0, Aug 4 2026) identified the absence of an About page as Finding 2, Severity: Medium. The reasoning was that a branded storefront typically benefits from a page communicating brand story and mission to build customer trust.

Following stakeholder review, the store owner (Jonathan Canales) rejected this recommendation. His stated preference is that the brand should not explicitly explain itself to customers; the products, visuals, and store presentation should communicate the brand identity on their own, without a dedicated narrative page. This is a stylistic/brand-voice preference, not a technical or budget constraint.

Decision
An About page will not be included in the MVP or the page structure generally. The site will retain its current page set: Home, All Products, category pages (Shirts / Sweatshirts & Hoodies / Accessories), Product Detail, Cart, Checkout, and Contact.

No route, component, or content model needs to be reserved for About-page content in the frontend or CMS/admin structure.

Alternatives Considered
Full About page (original audit recommendation) - rejected; conflicts with the owner's preferred brand voice of letting products speak for themselves.

Minimal brand blurb elsewhere -  not requested by the owner; not included in MVP scope, but not precluded by this decision if raised later.

Consequences
Site page count and navigation structure stay simpler, matching the current live storefront.

No engineering time spent on About-page routing, content fields, or admin editing UI for that page.

The original audit finding (Finding 2, Audit Report v1.0) is not altered; this ADR documents a deliberate deviation based on direct stakeholder input, not a correction of an error.

Related
docs/discovery/Audit_Report.pdf — Finding 2, Section 10
docs/adr/0001_defer_product_filtering.md — related pattern of stakeholder overriding a general best-practice recommendation
