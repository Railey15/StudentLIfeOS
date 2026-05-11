create table if not exists public.budget_profiles (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  initial_budget numeric(12,2) not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists public.budget_categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  planned_amount numeric(12,2) not null default 0,
  created_at timestamptz not null default now()
);

alter table public.budget_entries
add column if not exists category_id uuid references public.budget_categories(id) on delete set null;

alter table public.marketplace_listings
add column if not exists listing_type text check (listing_type in ('Sell', 'Trade')) default 'Sell';

alter table public.marketplace_listings
add column if not exists image_url text;

alter table public.marketplace_listings
add column if not exists seller_name text;

create table if not exists public.chat_conversations (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid references public.marketplace_listings(id) on delete set null,
  listing_title text,
  buyer_id uuid not null references public.profiles(id) on delete cascade,
  buyer_name text,
  seller_id uuid not null references public.profiles(id) on delete cascade,
  seller_name text,
  last_message text,
  last_message_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.chat_conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  sender_name text,
  message text not null,
  created_at timestamptz not null default now()
);

alter table public.budget_profiles enable row level security;
alter table public.budget_categories enable row level security;
alter table public.chat_conversations enable row level security;
alter table public.chat_messages enable row level security;

create policy "budget_profiles_manage_own"
on public.budget_profiles for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "budget_categories_manage_own"
on public.budget_categories for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "chat_conversations_visible_to_participants"
on public.chat_conversations for all
using (auth.uid() = buyer_id or auth.uid() = seller_id)
with check (auth.uid() = buyer_id or auth.uid() = seller_id);

create policy "chat_messages_visible_to_participants"
on public.chat_messages for all
using (
  exists (
    select 1
    from public.chat_conversations c
    where c.id = conversation_id
      and (c.buyer_id = auth.uid() or c.seller_id = auth.uid())
  )
)
with check (
  exists (
    select 1
    from public.chat_conversations c
    where c.id = conversation_id
      and (c.buyer_id = auth.uid() or c.seller_id = auth.uid())
  )
);

drop policy if exists "marketplace_listings_manage_own" on public.marketplace_listings;
create policy "marketplace_listings_manage_own"
on public.marketplace_listings for all
using (auth.uid() = seller_id)
with check (auth.uid() = seller_id);

drop policy if exists "marketplace_listings_public_read" on public.marketplace_listings;
create policy "marketplace_listings_public_read"
on public.marketplace_listings for select
using (true);
