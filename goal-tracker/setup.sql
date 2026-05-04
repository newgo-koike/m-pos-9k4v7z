-- ============================================================
-- Goal Tracker — Supabase スキーマ
-- 実行手順：Supabase ダッシュボード → SQL Editor → New query → 全文貼付 → Run
-- ============================================================

-- 1. テーブル作成（state を JSONB で丸ごと保存）
create table if not exists public.goal_tracker_states (
  user_id uuid references auth.users(id) on delete cascade primary key,
  state_json jsonb not null,
  updated_at timestamptz not null default now()
);

-- 2. RLS（Row Level Security）有効化 — 他ユーザーの行は一切触れない
alter table public.goal_tracker_states enable row level security;

-- 3. ポリシー：自分の行のみ select / insert / update できる
drop policy if exists "Users can read own state" on public.goal_tracker_states;
create policy "Users can read own state"
  on public.goal_tracker_states
  for select
  using (auth.uid() = user_id);

drop policy if exists "Users can insert own state" on public.goal_tracker_states;
create policy "Users can insert own state"
  on public.goal_tracker_states
  for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users can update own state" on public.goal_tracker_states;
create policy "Users can update own state"
  on public.goal_tracker_states
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 4. 確認用クエリ（実行不要・Verify用）
-- select * from public.goal_tracker_states;
