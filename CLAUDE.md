# Claude Code 固有の設定

このドキュメントは、Claude Code向けの固有設定と指示を記載しています。

---

## 基本方針（変更禁止）

**⚠️ このセクションは人間が管理します。AIによる変更は禁止です。**

### ドキュメント参照の優先順位

コードを書く前に、必ず以下の順序でドキュメントを確認してください：

1. **[AGENTS.md](AGENTS.md)** - AI向けの基本指示
2. **docs/ 配下のドキュメント** - 詳細なルールと方針
   - [docs/CODING_RULES.md](docs/CODING_RULES.md) - コード規約
   - [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - 設計方針
   - [docs/DATABASE.md](docs/DATABASE.md) - DB設計ルール
   - [docs/LOGGING.md](docs/LOGGING.md) - ログ規約
   - [docs/SECURITY.md](docs/SECURITY.md) - セキュリティ設計
   - [docs/TESTING.md](docs/TESTING.md) - テスト方針
   - [docs/GIT_RULES.md](docs/GIT_RULES.md) - Git運用ルール
   - [docs/ISSUE_RULES.md](docs/ISSUE_RULES.md) - Issue運用ルール
   - [docs/WORKFLOW.md](docs/WORKFLOW.md) - 開発の進め方

### MCP利用ルール

#### Context7の使用

最新のライブラリドキュメントやベストプラクティスを確認する際は、**必ずContext7を使用**してください。

```
# 良い例
「Context7でFastAPIの最新の認証実装方法を確認してから実装します」
「Context7でReact 18のSuspenseの使い方を確認します」

# 悪い例
「知識の範囲内で実装します」（古い情報の可能性がある）
```

#### その他のMCP

- **GitHub MCP**: Issue/PRの操作が必要な場合
- **PostgreSQL MCP**: データベース構造の確認が必要な場合

### 禁止事項

以下の行為は厳禁です：

1. ❌ **ドキュメントを読まずにコードを書く**
2. ❌ **テストなしで実装する**
3. ❌ **セキュリティ対策を省略する**
4. ❌ **大きな変更を一度に行う**
5. ❌ **このセクション（基本方針）を変更する**
6. ❌ **機密情報をハードコードする**
7. ❌ **エラーハンドリングを省略する**

### 実装前の確認事項

コードを書く前に、必ず以下を確認してください：

- [ ] 該当するドキュメントを読んだか
- [ ] テストを先に作成したか（TDD）
- [ ] セキュリティリスクを考慮したか
- [ ] エラーハンドリングを設計したか
- [ ] 変更が小さな単位に分割されているか

---

## 現状のAPI一覧（更新可能）

**✅ このセクションはAIが更新できます。**

API実装時は、このセクションに追記してください。

### エンドポイント一覧

**[`/update-docs` コマンドで更新してください]**

```
# 現在、APIエンドポイントは未定義です
# 実装後、以下の形式で記載してください：

## [カテゴリ名]

### [HTTPメソッド] /api/xxx
- **概要**: xxxを取得する
- **認証**: 必要/不要
- **リクエスト**:
  - パラメータ: xxx
- **レスポンス**:
  - 成功: 200 OK
  - エラー: 400 Bad Request
```

---

## 現状のテーブル一覧（更新可能）

**✅ このセクションはAIが更新できます。**

テーブル作成時は、このセクションに追記してください。

### データベーススキーマ

**[`/update-docs` コマンドで更新してください]**

```
# 現在、テーブルは未定義です
# 実装後、以下の形式で記載してください：

## テーブル名: xxx

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | NO | AUTO_INCREMENT | 主キー |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP | 更新日時 |
| deleted_at | timestamp | YES | NULL | 削除日時（論理削除） |

**インデックス**:
- PRIMARY KEY (id)
- INDEX idx_xxx (xxx)

**外部キー**:
- FOREIGN KEY (xxx_id) REFERENCES xxx(id)
```

---

## 開発時の注意事項

### コミットの粒度

- 1つの機能/修正ごとにコミットする
- `/commit` コマンドを使用してConventional Commits形式でコミットする
- 複数の変更を1つのコミットにまとめない

### コンテキスト管理

- 作業が長時間に渡る場合は、新しいセッションを開始する
- セッション開始時は、前回までの進捗を確認してから作業を開始する
- Git履歴から状況を把握できる

### レビュー依頼

- `/code-review` コマンドで自己レビューを実施する
- レビュー結果に基づいて修正を行う
- 修正後、再度レビューを実施する

---

## スラッシュコマンドの使い方

詳細は `.claude/commands/` 配下のファイルを参照してください。

### 初期設定（1回のみ）

```
/init-project
```

### 日常的に使用するコマンド

```
/create-test      # テスト作成
/implement-for-test  # 実装
/code-review      # レビュー
/commit          # コミット
/create-pr       # PR作成
```

### メンテナンス

```
/update-docs     # このドキュメントの更新
/check-rules     # ルール違反チェック
/explain         # コード説明
```

---

## トラブルシューティング

### テストが失敗する

1. `/code-review` でコードをレビュー
2. エラーメッセージを確認
3. [docs/TESTING.md](docs/TESTING.md) を参照
4. 不明な場合は開発者に質問

### ルール違反が指摘された

1. `/check-rules` でルール違反を確認
2. 該当するドキュメントを再確認
3. 修正後、再度 `/check-rules` を実行

### コミットメッセージが不適切

1. [docs/GIT_RULES.md](docs/GIT_RULES.md) を確認
2. `/commit` コマンドを使用（自動生成）

---

## 更新履歴

このセクションには、重要な変更のみを記録してください。

- **[日付]**: `/init-project` でプロジェクト初期化
