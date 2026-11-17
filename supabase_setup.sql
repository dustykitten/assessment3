-- Run this once in Supabase: SQL Editor > New query > paste > Run.
-- Change CHANGE_ME below to your own teacher password FIRST.

create extension if not exists pgcrypto with schema extensions;

create table if not exists public.responses (
  id text primary key,
  name text,
  locked int default 0,
  answers jsonb,
  updated bigint
);
create table if not exists public.teacher (
  id text primary key,
  pw_hash text not null
);

-- Nobody can read or write these tables directly. Everything goes through the two functions below.
alter table public.responses enable row level security;
alter table public.teacher enable row level security;

insert into public.teacher (id, pw_hash)
values ('lwarden', extensions.crypt('CHANGE_ME', extensions.gen_salt('bf')))
on conflict (id) do update set pw_hash = excluded.pw_hash;

create or replace function public.save_response(p_id text, p_name text, p_locked int, p_answers jsonb)
returns void language sql security definer set search_path = public as $$
  insert into public.responses (id, name, locked, answers, updated)
  values (p_id, p_name, p_locked, p_answers, (extract(epoch from now()) * 1000)::bigint)
  on conflict (id) do update
    set name = excluded.name, locked = excluded.locked, answers = excluded.answers, updated = excluded.updated;
$$;

create or replace function public.teacher_list(p_id text, p_pw text)
returns setof public.responses language plpgsql security definer set search_path = public, extensions as $$
begin
  if not exists (select 1 from public.teacher where id = p_id and pw_hash = extensions.crypt(p_pw, pw_hash)) then
    raise exception 'denied';
  end if;
  return query select * from public.responses order by updated desc;
end;
$$;

revoke all on function public.save_response(text, text, int, jsonb) from public;
revoke all on function public.teacher_list(text, text) from public;
grant execute on function public.save_response(text, text, int, jsonb) to anon;
grant execute on function public.teacher_list(text, text) to anon;
