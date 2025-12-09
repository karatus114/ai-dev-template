# Git運用ルール

このドキュメントでは、Gitのコミット、ブランチ、プルリクエストに関するルールを定義します。

---

## コミットメッセージ

### Conventional Commits形式

すべてのコミットメッセージは、**Conventional Commits**形式に従ってください。

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 基本形式

```
<type>: <subject>
```

**例**:
```
feat: ユーザー登録機能を追加
fix: ログイン時のバリデーションエラーを修正
docs: READMEにセットアップ手順を追加
```

### type一覧

| type | 用途 | 例 |
|------|------|---|
| `feat` | 新機能の追加 | `feat: ユーザー検索機能を追加` |
| `fix` | バグ修正 | `fix: パスワードリセット時のエラーを修正` |
| `docs` | ドキュメントのみの変更 | `docs: API仕様書を更新` |
| `style` | コードの動作に影響しない変更（フォーマット等） | `style: インデントを修正` |
| `refactor` | リファクタリング | `refactor: UserServiceを関数に分割` |
| `test` | テストの追加・修正 | `test: ユーザー登録のテストを追加` |
| `chore` | ビルドプロセスやツールの変更 | `chore: 依存関係を更新` |
| `perf` | パフォーマンス改善 | `perf: データベースクエリを最適化` |

### scope（オプション）

変更の範囲を示す。

```
feat(auth): ログイン機能を追加
fix(user): プロフィール更新時のバグを修正
docs(api): エンドポイント一覧を更新
```

### subject

- **現在形で記述する**（「追加した」ではなく「追加」）
- **日本語または英語**
- **50文字以内**を推奨
- **ピリオドで終わらない**

### 良い例・悪い例

```
✅ 良い例:
feat: ユーザー検索機能を追加
fix: ログイン時の認証エラーを修正
docs: セットアップ手順を更新

❌ 悪い例:
add user search  (typeがない)
fixed bug  (具体性がない)
feat: ユーザー検索機能を追加しました。 (過去形、ピリオド)
```

### body（オプション）

詳細な説明が必要な場合に記述する。

```
feat: ユーザー検索機能を追加

名前、メールアドレス、登録日で検索できるようにした。
ページネーションにも対応している。

Closes #123
```

### footer（オプション）

Issueの参照や破壊的変更を記述する。

```
feat: 認証APIをv2に更新

BREAKING CHANGE: /api/auth/login のレスポンス形式が変更されました

Closes #456
```

---

## ブランチ戦略

### ブランチ命名規則

```
<type>/<issue番号>-<説明>
```

**例**:
```
feat/123-add-user-search
fix/456-login-validation-error
docs/789-update-readme
```

### type一覧

コミットメッセージのtypeと同じものを使用してください。

| type | 用途 |
|------|------|
| `feat` | 新機能 |
| `fix` | バグ修正 |
| `docs` | ドキュメント |
| `refactor` | リファクタリング |
| `test` | テスト |
| `chore` | その他 |

### 良い例・悪い例

```
✅ 良い例:
feat/123-user-search
fix/456-login-error
docs/789-api-spec

❌ 悪い例:
feature-123  (typeが略されていない)
123-user-search  (typeがない)
feat/user-search  (Issue番号がない)
```

### メインブランチ

- **main** または **master**: 本番環境にデプロイされるブランチ
- **develop**（オプション）: 開発用のブランチ（必要に応じて使用）

### ブランチの運用フロー

```
1. mainブランチから新しいブランチを作成
   git checkout -b feat/123-user-search

2. コミットを積み重ねる
   git add .
   git commit -m "feat: ユーザー検索機能を追加"

3. リモートにプッシュ
   git push -u origin feat/123-user-search

4. プルリクエストを作成
   gh pr create

5. レビュー・マージ

6. ブランチを削除
   git branch -d feat/123-user-search
```

---

## プルリクエスト（PR）

### PRタイトル

コミットメッセージと同じ形式を使用してください。

```
feat: ユーザー検索機能を追加
fix: ログイン時のバリデーションエラーを修正
```

### PR本文

`.github/PULL_REQUEST_TEMPLATE.md` のテンプレートに従って記述してください。

```markdown
## 概要

ユーザー検索機能を追加しました。

## 変更内容

- [ ] ユーザー検索APIの実装
- [ ] フロントエンドの検索フォーム実装
- [ ] テストの追加

## 関連Issue

Closes #123

## テスト

- [ ] ユニットテストが通ることを確認
- [ ] 手動テストで動作確認

## レビュー観点

- セキュリティ上の問題がないか
- パフォーマンスに影響がないか
```

### PRのルール

#### 作成前

- [ ] テストがすべてパスしていることを確認
- [ ] リンター・フォーマッターを実行
- [ ] 不要なコメントやconsole.logを削除
- [ ] コミットメッセージがConventional Commits形式に従っている

#### レビュー

- [ ] 最低1人のレビュアーの承認が必要
- [ ] CIが通っていることを確認
- [ ] コンフリクトがないことを確認

#### マージ

- **Squash and merge**を推奨（コミット履歴を整理）
- マージ後、ブランチを削除

---

## コミットのルール

### コミットの粒度

- **1つの機能/修正ごとにコミットする**
- **複数の変更を1つのコミットにまとめない**

```
✅ 良い例:
git commit -m "feat: ユーザー検索APIを追加"
git commit -m "test: ユーザー検索のテストを追加"
git commit -m "docs: API仕様書を更新"

❌ 悪い例:
git commit -m "feat: ユーザー検索機能の実装、テスト追加、ドキュメント更新"
```

### コミット前の確認

- [ ] テストがパスしているか
- [ ] リンター・フォーマッターを実行したか
- [ ] 不要なファイルが含まれていないか（.env, node_modules/等）
- [ ] コミットメッセージが適切か

### `/commit` コマンドの使用

Claude Codeを使用している場合は、`/commit` コマンドでConventional Commits形式のコミットを自動生成できます。

```
/commit
```

---

## Gitフック（オプション）

### pre-commit

コミット前に自動実行されるスクリプト。

```bash
#!/bin/sh
# .git/hooks/pre-commit

# リンター実行
npm run lint

# フォーマッター実行
npm run format

# テスト実行（オプション）
# npm run test
```

### commit-msg

コミットメッセージの検証。

```bash
#!/bin/sh
# .git/hooks/commit-msg

# Conventional Commits形式をチェック
npx commitlint --edit $1
```

---

## .gitignore

すべてのプロジェクトで、以下のファイル・ディレクトリを除外してください。

詳細は [.gitignore](.gitignore) を参照してください。

### 主な除外項目

- **環境変数**: `.env`, `.env.local`
- **認証情報**: `*.pem`, `*.key`, `credentials.json`
- **IDE設定**: `.idea/`, `.vscode/settings.json`
- **依存関係**: `node_modules/`, `__pycache__/`
- **ビルド成果物**: `dist/`, `build/`
- **ログ**: `*.log`, `logs/`

---

## タグ

### セマンティックバージョニング

リリース時は、セマンティックバージョニング（SemVer）に従ってタグを作成してください。

```
v<major>.<minor>.<patch>

例:
v1.0.0
v1.1.0
v1.1.1
```

### タグの作成

```bash
# タグ作成
git tag -a v1.0.0 -m "Release version 1.0.0"

# タグをプッシュ
git push origin v1.0.0
```

---

## マージコンフリクトの解決

### 基本手順

```bash
# 最新のmainを取得
git checkout main
git pull origin main

# 自分のブランチにマージ
git checkout feat/123-user-search
git merge main

# コンフリクトを解決
# (ファイルを編集)

# 解決後、コミット
git add .
git commit -m "chore: mainブランチをマージ"
```

### コンフリクト解消時の注意

- **両方の変更を確認する**
- **不要なマーカーを削除する**（`<<<<<<<`, `=======`, `>>>>>>>`）
- **テストを実行して動作確認する**

---

## 禁止事項

- ❌ **mainブランチに直接コミット**
- ❌ **Conventional Commits形式以外のコミットメッセージ**
- ❌ **複数の変更を1つのコミットにまとめる**
- ❌ **機密情報をコミット**（.env, APIキー等）
- ❌ **強制プッシュ（force push）** - 特にmainブランチには厳禁
- ❌ **テストが失敗している状態でコミット**

---

## ベストプラクティス

### 頻繁にコミットする

- 小さな変更をこまめにコミットする
- 作業が途中でも、意味のある単位でコミットする

### コミット前にdiffを確認する

```bash
git diff
git diff --staged
```

### コミット後は早めにプッシュする

```bash
git push
```

### ブランチは短命にする

- PRを作成したら、早めにマージする
- マージ後、ブランチを削除する

---

## 参考資料

- [Conventional Commits](https://www.conventionalcommits.org/)
- [ISSUE_RULES.md](ISSUE_RULES.md) - Issue運用ルール
- [WORKFLOW.md](WORKFLOW.md) - 開発の進め方

---

## 更新履歴

- **[日付]**: ドキュメント作成
