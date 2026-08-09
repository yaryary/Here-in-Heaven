# Here in Heaven — Full-Stack E-Commerce Rebuild

A custom-built storefront for a real apparel and merchandise brand, replacing its current Big Cartel-hosted shop with a full-stack web application.

**Status:** Phase 0 — Discovery & Requirements (in progress, no code yet)
**Current live site (being replaced):** [hereinheaven.net](https://hereinheaven.net)

---

## About This Project

Here in Heaven is a real brand run by Jonathan Canales, selling apparel and accessories through Big Cartel. He asked me to rebuild the storefront as a custom application he can actually use to run the business, rather than a class project or tutorial clone. I'm the sole developer, working directly with him as the client to figure out what the site needs to do before writing any code.

I'm a recent Computer Science graduate, and this is my first project of this size. I don't have industry experience yet, so I'm being intentional about following a process I'd want to be evaluated on: understand the problem, design before building, and write down *why* decisions were made, not just what they are.

## The Problem I'm Solving

The current storefront works, but it's limited by the platform it's built on:

- No way to sort or filter products (by price, category, size, or color)
- No custom admin tools beyond what Big Cartel provides
- No room to grow past a small catalog without hitting platform limits
- No customer accounts or order history

The goal is a production-ready application the owner can manage directly, with room to grow as his catalog does.

## What I've Done So Far (Phase 0)

Before touching any code, I audited the existing site and documented what it does, what's missing, and what the rebuild needs to support:

- **[Working Notes](./docs/discovery/Working_Notes.pdf)** — my raw, page-by-page notes taken while walking through the live storefront. These are unpolished on purpose; I kept them as-is to show the actual starting point rather than cleaning them up after the fact.

- **[Audit Report](./docs/discovery/Audit-Report-Filled.pdf)** — a page-by-page review of the current storefront, with findings and priorities for the rebuild
- **[Data Model Draft](./docs/design/Data-Model-Draft.pdf)** — my first pass at the database entities (Users, Products, Categories, Orders, Cart, Inventory, Discounts, Payments), including the reasoning behind each field and constraint
- **[Schema Diagram](./docs/design/Here-in-Heaven-Schema.png)** — a visual map of how those entities connect
- **[Screenshots](./docs/screenshots/)** — captures of every page on the current site, used as a reference for what to keep and what to improve

### Decisions I've Documented (`docs/adr/`)

Some of my audit's initial recommendations didn't match what the store owner actually wanted. Rather than just changing my notes, I kept a record of what the general best practice would suggest, what was decided instead, and why, so the reasoning is visible, not just the outcome:

- **[ADR 0001](./docs/adr/0001-defer-product-filtering.md)** — decided not to build sort/filter for MVP. The audit flagged this as a gap based on standard e-commerce UX practice, but the owner prefers customers see the full catalog at a glance, and the catalog is small enough that this works fine for now.
- **[ADR 0002](./docs/adr/0002-no-about-page.md)** — decided not to add an About page. The audit recommended one for brand storytelling, but the owner wants the products and visuals to speak for themselves instead.

I'm keeping the original audit findings as-is rather than editing them, since they show what I identified first versus what I adjusted after getting stakeholder feedback.

## Tech Stack

| Layer | Tools |
|---|---|
| Frontend | React (Vite), Tailwind CSS, React Router |
| Backend | Node.js, Express.js |
| Database | PostgreSQL |
| Auth | JWT |
| Payments | Stripe |
| Images | Cloudinary |
| Email | SendGrid / Resend |
| Deployment | Vercel (frontend), Railway/Render (backend + database) |

I chose PostgreSQL over MySQL mainly for stronger consistency guarantees around money-related data (orders, payments). The reasoning is written out in the Data Model Draft linked above.

## Roadmap

- [x] Phase 0 — Store audit, requirements gathering, data model draft, key decisions documented
- [ ] Phase 1 — Finalize database schema, plan API endpoints, sketch system architecture
- [ ] Phase 2 — Build backend: Express API, PostgreSQL setup, authentication
- [ ] Phase 3 — Build frontend: product catalog, product pages, cart, Stripe checkout
- [ ] Phase 4 — Build admin tools: add/edit/delete products, view orders, upload images
- [ ] Phase 5 — Deploy, write up a case study, final polish

