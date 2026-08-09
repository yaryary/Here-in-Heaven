ADR 0001: Defer Product Sorting/Filtering in MVP

Status
Accepted — August 9, 2026

Context
The Current Store Audit Report (v1.0, Aug 4 2026) identified the absence of product sorting (price, newest, featured) and filtering (category, size, color) as a High severity finding, based on general e-commerce UX best practice. The recommendation was to build native sort/filter into the product listing API and UI from day one to allow customers to better navigate the catalog.

Following stakeholder review, the store owner (Jonathan Canales) stated a clear preference: customers should be able to see the entire catalog at a glance, without needing to filter first. The current catalog is small (22 products across 3 categories), and the owner considers this simplicity a deliberate choice, not an oversight.

Decision
Sorting and filtering will not be included in the MVP. The product listing pages (Home, All Products, category pages) will continue to display the full catalog in a static grid, consistent with the current storefront experience.

The underlying database schema (categories, products, product_variants) will still store category_id, size, and color as structured, queryable fields so filtering can be added later without a schema migration if the catalog grows or the owner's preference changes.

Alternatives Considered
Full sort/filter UI in MVP (original audit recommendation) - rejected for now, adds UI complexity and friction the owner does not want at the current catalog size.

Partial filtering (category only, no size/color) - considered as a middle ground, also rejected per owner's explicit preference for an unfiltered browsing view.

Consequences
Product discovery for this catalog size will rely on the existing 3-column grid, category nav links, and search, matching the current site's layout.

Schema will still support size/color as filterable attributes, so this decision can be revisited without re-architecting the database if the catalog grows past roughly 50 products.

The original audit finding (Finding 1, Audit Report v1.0) is not altered. This ADR documents a deliberate deviation from that recommendation based on direct stakeholder input, not a correction of an error.

Related
docs/discovery/Audit_Report.pdf — Finding 1, Section 10
docs/design/Data_Model_Draft.pdf — Category, Product, Product_Variant tables
