create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text unique not null,
  campus text,
  program text,
  year_level text,
  student_id text,
  bio text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_settings (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  push_notifications boolean not null default true,
  deadline_reminders boolean not null default true,
  marketplace_messages boolean not null default true,
  biometric_lock boolean not null default false,
  dark_mode boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.subjects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  code text not null,
  title text not null,
  grade text,
  progress numeric(5,2) default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.academic_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  subject_id uuid references public.subjects(id) on delete set null,
  title text not null,
  deadline timestamptz,
  details text,
  priority text check (priority in ('Low', 'Medium', 'High')) default 'Medium',
  status text check (status in ('To Do', 'In Progress', 'Done')) default 'To Do',
  created_at timestamptz not null default now()
);

create table if not exists public.wellness_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  mood text not null,
  score int not null check (score between 1 and 5),
  note text,
  logged_at timestamptz not null default now()
);

create table if not exists public.budget_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  amount numeric(12,2) not null,
  category text not null,
  entry_type text check (entry_type in ('Income', 'Expense')) default 'Expense',
  spent_at timestamptz not null default now()
);

create table if not exists public.campus_places (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  place_type text not null,
  walk_time text,
  crowd_status text,
  description text,
  is_active boolean not null default true
);

create table if not exists public.marketplace_listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  category text not null,
  price numeric(12,2),
  description text,
  status text check (status in ('Active', 'Sold', 'Archived')) default 'Active',
  created_at timestamptz not null default now()
);

create table if not exists public.group_projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text,
  deadline timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.project_tasks (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.group_projects(id) on delete cascade,
  assignee_id uuid references public.profiles(id) on delete set null,
  title text not null,
  status text check (status in ('To Do', 'In Progress', 'Done')) default 'To Do',
  contribution_percent numeric(5,2) default 0,
  deadline timestamptz
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  announcement_type text not null,
  description text,
  event_date timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  action text not null,
  entity_name text not null,
  entity_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (
    id,
    full_name,
    email
  )
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', 'Student User'),
    new.email
  )
  on conflict (id) do nothing;

  insert into public.user_settings (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.user_settings enable row level security;
alter table public.subjects enable row level security;
alter table public.academic_tasks enable row level security;
alter table public.wellness_logs enable row level security;
alter table public.budget_entries enable row level security;
alter table public.marketplace_listings enable row level security;
alter table public.group_projects enable row level security;
alter table public.project_tasks enable row level security;

create policy "profiles_select_own"
on public.profiles for select
using (auth.uid() = id);

create policy "profiles_update_own"
on public.profiles for update
using (auth.uid() = id);

create policy "settings_manage_own"
on public.user_settings for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "subjects_manage_own"
on public.subjects for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "academic_tasks_manage_own"
on public.academic_tasks for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "wellness_logs_manage_own"
on public.wellness_logs for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "budget_entries_manage_own"
on public.budget_entries for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "marketplace_listings_manage_own"
on public.marketplace_listings for all
using (auth.uid() = seller_id)
with check (auth.uid() = seller_id);

create policy "group_projects_manage_own"
on public.group_projects for all
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

create policy "project_tasks_manage_related"
on public.project_tasks for all
using (
  exists (
    select 1
    from public.group_projects gp
    where gp.id = project_id
      and gp.owner_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.group_projects gp
    where gp.id = project_id
      and gp.owner_id = auth.uid()
  )
);

create policy "campus_places_public_read"
on public.campus_places for select
using (true);

create policy "announcements_public_read"
on public.announcements for select
using (true);
