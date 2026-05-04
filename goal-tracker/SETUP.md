# Goal Tracker — Supabase 連携セットアップ

3名（小池・兵頭・岩崎）の認証付きトライアルに切り替えるための手順。所要15分。

---

## ステップ 1：Supabase プロジェクトを新規作成

1. https://supabase.com/dashboard にアクセス（GitHubアカウントでログイン）
2. **New project** → 以下を入力
   - **Project name**: `Pharma Eight∞ Tool`
   - **Database password**: 任意（後で使わない、強固なものを生成）
   - **Region**: `Northeast Asia (Tokyo)` 推奨
   - **Pricing plan**: Free
3. プロジェクト作成完了まで2-3分待つ

## ステップ 2：DB スキーマを実行

1. 左メニュー **SQL Editor** → **New query**
2. このリポジトリの `setup.sql` の中身を全部貼り付け
3. 右下の **Run** をクリック → "Success" 表示されればOK

## ステップ 3：URL と anon key を取得

1. 左メニュー **Settings** → **API**
2. 以下2つをコピー：
   - **Project URL**（例: `https://abcdefghi.supabase.co`）
   - **Project API keys** → **anon / public**（長い JWT）

## ステップ 4：`config.js` に貼り付け

`goal-tracker/config.js` を開いて以下を書き換え：

```js
const SUPABASE_CONFIG = {
  url: 'https://abcdefghi.supabase.co',     // ← Project URL
  anonKey: 'eyJhbGc......'                  // ← anon key
};
```

> ⚠ anon key はブラウザに公開される「公開キー」なので git にコミットしてOK。
> 本物のセキュリティは Postgres の RLS（setup.sql で設定済み）で担保されています。

## ステップ 5：3名分のアカウントを発行

1. Supabase ダッシュボード左メニュー **Authentication** → **Users**
2. **Add user** → **Create new user** で以下3名分を作成：
   - 小池: `y-koike@yumematch.com` + パスワード（任意）
   - 兵頭: 兵頭さんのメールアドレス + パスワード
   - 岩崎: 岩崎さんのメールアドレス + パスワード
3. ⚠ **Auto Confirm User** にチェック（メール認証スキップ）

⚠ パスワードは LINE / Slack 等で各人に直接共有してください。
初回ログイン後に各自で変更してもらえると尚良し。

## ステップ 6：デプロイ

```bash
cd /Users/yugo/Dropbox/Obsidian/Personal-OS-deploy
git add goal-tracker/
git commit -m "Add Supabase auth + multi-user support"
git push
```

GitHub Pages に反映されたら以下のURLでログイン画面が表示される：
👉 https://newgo-koike.github.io/m-pos-9k4v7z/goal-tracker/

## トラブルシューティング

| 症状 | 原因 | 対応 |
|---|---|---|
| ログイン画面が出ない・真っ白 | config.js が未設定 | ステップ 4 を再実行 |
| ログインできない（"Invalid login credentials"） | パスワード違い or Auto Confirm 未チェック | Supabase Authentication でパスワード再設定 |
| ログイン後にデータが保存されない | RLS ポリシー未設定 | setup.sql を再実行 |
| "row violates RLS" エラー | user_id が auth.uid() と一致してない | コンソールで `(await sb.auth.getUser()).data.user.id` を確認 |

## 運用メモ

- データは Supabase の `goal_tracker_states` テーブルに 1ユーザー1行で保存される（state JSONを丸ごとJSONB列に格納）
- 自動保存：編集後 800ms のデバウンスで Supabase に同期
- localStorage は念のためのキャッシュとして残るが、source of truth は Supabase
- ログアウト時に localStorage は消える
