# MediTrack independent backend proposal

This is a **fictional-data demo only**. The SQL bootstrap is not deployed or verified in PostgreSQL. The existing static app still uses browser-local storage.

## Stage 1: isolated demo workspaces

Use a new dedicated Supabase project, not the ELITES SACCO project or an existing facility backend. Create invited test users. Disable public sign-up unless explicitly needed. Never use production patient data. Review the SQL before applying it.

The proposed table stores one JSON snapshot per authenticated user. Row-level policies scope read, insert, update and delete to that user's UUID. Anonymous access is revoked. The 2 MiB limit is a basic storage bound, not a clinical schema. A revision column is reserved for future optimistic concurrency; the current SQL does not enforce revision increments.

## Required verification before enabling any frontend connection

- Confirm the project is dedicated to MediTrack.
- Apply the SQL, inspect database advisors and confirm API grants.
- With two separate invited test users, prove each can create and retrieve their own row but cannot read, change or delete the other's row.
- Prove unauthenticated requests cannot access the table.
- Implement session handling with a supported, pinned Supabase client; use only the publishable key in the browser.
- Implement explicit remote save/load, revision conflict detection, and visible error handling. Never silently fall back to a different user's workspace.
- Test sign-out and remove any cached remote data.

## Stage 2: shared departmental architecture

Owner-isolated snapshots are NOT shared hospital records or role-based departmental authorization. For a multi-user demo, design normalized tables and server-controlled facility membership, clinical roles, workflow transitions and audit logs. Enforce permissions in database policies and server-side transactions. Do not expose privileged credentials or trust frontend role labels. Validate inventory, payment and bed-allocation concurrency before any clinical deployment.

## Existing demo

Run `node tests/regression.mjs` from the repository root. The current browser-only demo requires no Supabase project.
