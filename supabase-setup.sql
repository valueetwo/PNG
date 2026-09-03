-- PNG Dashboard: public-read, admin-write setup
-- Jalankan di Supabase SQL Editor satu kali.

create extension if not exists pgcrypto;

create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null,
  description text default '',
  duration text default '5:00',
  duration_label text default '',
  language text default 'Indonesia',
  thumbnail_url text default '',
  video_url text default '',
  tags text[] default '{}',
  created_at timestamptz not null default now()
);

create table if not exists public.materials (
  id uuid primary key default gen_random_uuid(),
  video_title text not null,
  title text not null,
  category text not null,
  summary text default '',
  content text not null,
  attachment_url text default '',
  created_at timestamptz not null default now()
);

create table if not exists public.faq (
  id uuid primary key default gen_random_uuid(),
  question text not null,
  answer text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.sop (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  content text not null,
  created_at timestamptz not null default now()
);

alter table public.videos enable row level security;
alter table public.materials enable row level security;
alter table public.faq enable row level security;
alter table public.sop enable row level security;

drop policy if exists "public read videos" on public.videos;
create policy "public read videos" on public.videos for select using (true);
drop policy if exists "admin write videos" on public.videos;
create policy "admin write videos" on public.videos for all to authenticated using (true) with check (true);

drop policy if exists "public read materials" on public.materials;
create policy "public read materials" on public.materials for select using (true);
drop policy if exists "admin write materials" on public.materials;
create policy "admin write materials" on public.materials for all to authenticated using (true) with check (true);

drop policy if exists "public read faq" on public.faq;
create policy "public read faq" on public.faq for select using (true);
drop policy if exists "admin write faq" on public.faq;
create policy "admin write faq" on public.faq for all to authenticated using (true) with check (true);

drop policy if exists "public read sop" on public.sop;
create policy "public read sop" on public.sop for select using (true);
drop policy if exists "admin write sop" on public.sop;
create policy "admin write sop" on public.sop for all to authenticated using (true) with check (true);

insert into storage.buckets (id,name,public)
values ('png-media','png-media',true)
on conflict (id) do update set public=true;

drop policy if exists "public read png media" on storage.objects;
create policy "public read png media" on storage.objects for select using (bucket_id='png-media');
drop policy if exists "admin upload png media" on storage.objects;
create policy "admin upload png media" on storage.objects for insert to authenticated with check (bucket_id='png-media');
drop policy if exists "admin update png media" on storage.objects;
create policy "admin update png media" on storage.objects for update to authenticated using (bucket_id='png-media') with check (bucket_id='png-media');
drop policy if exists "admin delete png media" on storage.objects;
create policy "admin delete png media" on storage.objects for delete to authenticated using (bucket_id='png-media');
