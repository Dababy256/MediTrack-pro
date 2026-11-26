-- Proposed bootstrap for an independent fictional-data Supabase project.
-- Not applied or tested against a live database. Do not use for clinical records.
begin;
create table public.meditrack_demo_workspaces (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  revision bigint not null default 0 check (revision >= 0),
  updated_at timestamptz not null default now(),
  constraint demo_state_object check (jsonb_typeof(state) = 'object'),
  constraint demo_state_size check (octet_length(state::text) <= 2097152)
);
alter table public.meditrack_demo_workspaces enable row level security;
revoke all on public.meditrack_demo_workspaces from public, anon, authenticated;
grant select, insert, update, delete on public.meditrack_demo_workspaces to authenticated;
create policy own_workspace_select on public.meditrack_demo_workspaces
  for select to authenticated using ((select auth.uid()) = owner_id);
create policy own_workspace_insert on public.meditrack_demo_workspaces
  for insert to authenticated with check ((select auth.uid()) = owner_id);
create policy own_workspace_update on public.meditrack_demo_workspaces
  for update to authenticated using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);
create policy own_workspace_delete on public.meditrack_demo_workspaces
  for delete to authenticated using ((select auth.uid()) = owner_id);
commit;
