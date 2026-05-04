// ============================================================
// Supabase configuration
// ----------------------------------------------------------
// 以下を Supabase ダッシュボードから取得した値に書き換えてください。
//   - URL: Settings → API → Project URL
//   - anon key: Settings → API → Project API keys → anon (public)
//
// anon key はブラウザに公開されることを前提とした「公開キー」です。
// 実際のセキュリティは Postgres の RLS（Row Level Security）で担保されます。
// setup.sql を Supabase の SQL Editor で実行してください。
// ============================================================
const SUPABASE_CONFIG = {
  url: 'https://kqumhqcbgfwwichozqqc.supabase.co',
  anonKey: 'sb_publishable_pinS3O3UwLGttnkZEm2G9w_bdRZw6Wg'
};
