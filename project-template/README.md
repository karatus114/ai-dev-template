# プロジェクト名

**[`/init-project` を実行してプロジェクト名を設定してください]**

## 概要

このプロジェクトは、AI駆動開発（Claude Code / Cursor）を活用したチーム開発用のテンプレートです。

**[`/init-project` を実行してプロジェクト概要を設定してください]**

---

## 技術スタック

**[`/init-project` を実行して技術スタックを設定してください]**

### フロントエンド

- [技術名] - [説明]

### バックエンド

- [技術名] - [説明]

### データベース

- [技術名] - [説明]

### その他

- [技術名] - [説明]

---

## セットアップ

### 前提条件

- Git
- GitHub CLI (`gh`)
- [技術スタックに応じた前提条件が `/init-project` で追加されます]

### 初回セットアップ

1. **リポジトリをクローン**

```bash
git clone [repository-url]
cd [repository-name]
```

2. **セットアップスクリプトを実行**

```bash
./setup.sh
```

または、Claude Code / Cursor で以下のコマンドを実行：

```
/setup
```

3. **プロジェクトの初期設定**

Claude Code / Cursor で以下のコマンドを実行（最初に1回のみ）：

```
/init-project
```

このコマンドで技術スタックを選択し、ドキュメントが自動生成されます。

4. **.env ファイルを編集**

`.env` ファイルを開いて、必要な環境変数を設定してください。

**最低限必要な設定**:
- `DATABASE_URL`: データベース接続URL
- `JWT_SECRET`: JWT署名用のシークレットキー（ランダムな32文字以上）

**JWT_SECRETの生成方法**:
```bash
openssl rand -base64 32
```

5. **依存関係をインストール**

**[`/init-project` で技術スタックに応じたコマンドが表示されます]**

6. **データベースのセットアップ**

**[`/init-project` で技術スタックに応じたコマンドが表示されます]**

---

## 開発の始め方

### 基本フロー

```
1. Issue作成 (/create-issue)
   ↓
2. ブランチ作成 (git checkout -b feat/xxx)
   ↓
3. テスト作成 (/create-test)
   ↓
4. 実装 (/implement-for-test)
   ↓
5. コミット (/commit)
   ↓
6. PR作成 (/create-pr)
```

### 詳細な開発フロー

詳細は [docs/WORKFLOW.md](docs/WORKFLOW.md) を参照してください。

---

## ディレクトリ構成

```
project-template/
│
├── docs/                              # ドキュメント（人間とAI共通）
│   ├── CODING_RULES.md                # コード規約・命名規則
│   ├── ARCHITECTURE.md                # 設計方針・レイヤー構成
│   ├── DATABASE.md                    # DB設計ルール
│   ├── LOGGING.md                     # ログ規約
│   ├── GIT_RULES.md                   # コミット/ブランチ/PR規約
│   ├── ISSUE_RULES.md                 # Issue運用ルール
│   ├── SECURITY.md                    # セキュリティ設計
│   ├── TESTING.md                     # テスト方針（TDD）
│   └── WORKFLOW.md                    # 開発の進め方
│
├── .claude/
│   └── commands/                      # Claude Code用スラッシュコマンド
│       ├── init-project.md            # プロジェクト初期設定
│       ├── setup.md                   # 新規参画者セットアップ
│       ├── code-review.md             # コードレビュー
│       ├── create-test.md             # テスト作成
│       ├── implement-for-test.md      # 実装
│       ├── commit.md                  # コミット
│       ├── create-pr.md               # PR作成
│       ├── create-issue.md            # Issue作成
│       ├── update-docs.md             # ドキュメント更新
│       ├── check-rules.md             # ルール違反チェック
│       └── explain.md                 # コード説明
│
├── .cursor/
│   ├── commands/                      # Cursor用（.claude/commandsへのリンク）
│   └── BUGBOT.md                      # BugBot用レビュールール
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── feature.md                 # 機能追加用テンプレート
│   │   └── bug.md                     # バグ報告用テンプレート
│   └── PULL_REQUEST_TEMPLATE.md       # PRテンプレート
│
├── AGENTS.md                          # AIエージェント共通の指示
├── CLAUDE.md                          # Claude Code固有の設定
├── .cursorrules                       # Cursor固有の設定
├── .mcp.json                          # MCP設定
├── .gitignore                         # Git除外設定
├── .env.example                       # 環境変数の見本
├── README.md                          # このファイル
└── setup.sh                           # 初期セットアップスクリプト
```

**[`/init-project` で技術スタックに応じたディレクトリ構成が追加されます]**

---

## ドキュメント

### 開発者向けドキュメント

| ドキュメント | 内容 |
|------------|------|
| [AGENTS.md](AGENTS.md) | AIエージェント向けの基本指示 |
| [CLAUDE.md](CLAUDE.md) | Claude Code固有の設定 |
| [docs/WORKFLOW.md](docs/WORKFLOW.md) | 開発の進め方 |
| [docs/TESTING.md](docs/TESTING.md) | テスト方針（TDD） |
| [docs/CODING_RULES.md](docs/CODING_RULES.md) | コード規約 |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | 設計方針 |
| [docs/DATABASE.md](docs/DATABASE.md) | DB設計ルール |
| [docs/SECURITY.md](docs/SECURITY.md) | セキュリティ設計 |
| [docs/LOGGING.md](docs/LOGGING.md) | ログ規約 |
| [docs/GIT_RULES.md](docs/GIT_RULES.md) | Git運用ルール |
| [docs/ISSUE_RULES.md](docs/ISSUE_RULES.md) | Issue運用ルール |

### AI駆動開発について

このプロジェクトでは、**Claude Code** または **Cursor** を使用したAI駆動開発を推奨しています。

#### 基本方針

- **小さく作る**: 1機能ごとに実装→テスト→レビュー→マージ
- **TDD（テスト駆動開発）**: 実装前にテストを作成
- **セキュリティファースト**: セキュリティ対策を最優先
- **ドキュメント参照**: 不明点はdocs/を確認してから実装

#### 使用可能なスラッシュコマンド

| コマンド | 用途 |
|---------|------|
| `/init-project` | プロジェクト初期設定（最初に1回実行） |
| `/setup` | 新規参画者向けセットアップ |
| `/create-test` | テスト作成（TDD） |
| `/implement-for-test` | テストに対する実装 |
| `/code-review` | コードレビュー |
| `/commit` | コミット作成（Conventional Commits形式） |
| `/create-pr` | PR作成 |
| `/create-issue` | Issue作成 |
| `/update-docs` | ドキュメント更新 |
| `/check-rules` | ルール違反チェック |
| `/explain` | コード説明 |

詳細は [docs/WORKFLOW.md](docs/WORKFLOW.md) を参照してください。

---

## MCP設定（オプション）

このテンプレートには**Context7 MCP**が設定済みです（追加設定不要）。

他のMCPを追加する場合は `.mcp.json` を編集してください。

### GitHub MCP

GitHub操作（Issue/PR管理）を強化したい場合：

1. GitHub Personal Access Token を作成
2. 環境変数 `GITHUB_TOKEN` を設定
3. `.mcp.json` に追加：

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### PostgreSQL MCP

DB構造の把握を強化したい場合：

1. 環境変数 `DATABASE_URL` を設定
2. `.mcp.json` に追加：

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

---

## テスト

### テストの実行

**[`/init-project` で技術スタックに応じたコマンドが表示されます]**

### TDD（テスト駆動開発）

このプロジェクトでは、TDDを採用しています。

```
1. /create-test（テスト作成）
   ↓
2. テスト実行（失敗を確認）
   ↓
3. /commit（テストをコミット）
   ↓
4. /implement-for-test（実装）
   ↓
5. テスト実行（成功を確認）
   ↓
6. /commit（実装をコミット）
```

詳細は [docs/TESTING.md](docs/TESTING.md) を参照してください。

---

## コミット規約

このプロジェクトでは、**Conventional Commits**形式を採用しています。

```
<type>: <subject>
```

### type一覧

- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント
- `style`: フォーマット
- `refactor`: リファクタリング
- `test`: テスト
- `chore`: その他

### 例

```
feat: ユーザー検索機能を追加
fix: ログイン時の認証エラーを修正
docs: READMEにセットアップ手順を追加
```

詳細は [docs/GIT_RULES.md](docs/GIT_RULES.md) を参照してください。

---

## ライセンス

**[ライセンスを記載してください]**

---

## コントリビューター

**[コントリビューターを記載してください]**

---

## 連絡先

**[連絡先を記載してください]**
