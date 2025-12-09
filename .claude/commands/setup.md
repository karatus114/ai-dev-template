新規参画者向けのセットアップを行います。

## 実行内容

### 1. 環境の確認

以下の項目を確認し、結果を表示してください：

#### 必要なランタイムのバージョン確認

**AGENTS.md から技術スタックを読み取り、必要なランタイムを確認してください。**

**Node.js プロジェクトの場合**:
```bash
node --version
npm --version
```

**Python プロジェクトの場合**:
```bash
python --version
pip --version
```

**その他のランタイム**:
技術スタックに応じて確認してください。

#### GitHub CLI の確認

```bash
gh --version
```

### 2. 必要なファイルの作成

#### .env ファイルの作成

`.env.example` から `.env` ファイルを作成してください。

```bash
# Windows
copy .env.example .env

# macOS/Linux
cp .env.example .env
```

### 3. 依存関係のインストール案内

**AGENTS.md から技術スタックを読み取り、適切なインストールコマンドを案内してください。**

**Node.js プロジェクトの場合**:
```bash
npm install
# または
yarn install
```

**Python プロジェクトの場合**:
```bash
pip install -r requirements.txt
# または
poetry install
```

### 4. データベースのセットアップ案内（該当する場合）

**AGENTS.md または docs/DATABASE.md からデータベース情報を読み取り、セットアップ手順を案内してください。**

例：
```bash
# マイグレーション実行
npm run migrate
# または
python manage.py migrate
```

### 5. 次のステップの案内

以下の情報を案内してください：

#### .env の編集が必要な項目

`.env.example` を参照し、編集が必要な項目を一覧表示してください。

例：
```
以下の環境変数を設定してください：
- DATABASE_URL: データベース接続URL
- JWT_SECRET: JWT署名用のシークレットキー（ランダムな32文字以上の文字列）
- API_KEY: 外部API用のキー（該当する場合）
```

#### 参照すべきドキュメント

```
📚 参照すべきドキュメント:
- AGENTS.md: AI向けの基本指示
- docs/WORKFLOW.md: 開発の進め方
- docs/CODING_RULES.md: コード規約
- docs/TESTING.md: テスト方針
- docs/GIT_RULES.md: Git運用ルール
```

#### 使用可能なスラッシュコマンド一覧

```
💡 利用可能なスラッシュコマンド:
- /create-test - テスト作成
- /implement-for-test - 実装
- /code-review - コードレビュー
- /commit - コミット
- /create-pr - PR作成
- /create-issue - Issue作成
- /update-docs - ドキュメント更新
- /check-rules - ルール違反チェック
- /explain - コード説明
```

## 出力形式

セットアップ状況をチェックリスト形式で表示し、未完了の項目について具体的な対応方法を案内してください。

### 出力例

```
🎉 新規参画者向けセットアップ

## ✅ 環境確認

- [✓] Node.js v18.17.0
- [✓] npm 9.6.7
- [✓] GitHub CLI 2.32.0

## 📋 セットアップ手順

### 1. .env ファイルの作成

以下のコマンドを実行してください：

\`\`\`bash
cp .env.example .env
\`\`\`

次に、`.env` ファイルを編集して、以下の環境変数を設定してください：

- **DATABASE_URL**: データベース接続URL
  例: `postgresql://user:password@localhost:5432/dbname`

- **JWT_SECRET**: JWT署名用のシークレットキー
  ランダムな32文字以上の文字列を設定してください
  生成方法: `openssl rand -base64 32`

- **API_KEY**: 外部API用のキー（該当する場合）

### 2. 依存関係のインストール

以下のコマンドを実行してください：

\`\`\`bash
npm install
\`\`\`

### 3. データベースのセットアップ

以下のコマンドを実行してください：

\`\`\`bash
npm run migrate
\`\`\`

## 📚 次のステップ

セットアップが完了したら、以下のドキュメントを確認してください：

1. **docs/WORKFLOW.md** - 開発の進め方を理解する
2. **docs/TESTING.md** - TDDのアプローチを理解する
3. **docs/CODING_RULES.md** - コード規約を確認する

## 💡 開発を始める

1. Issue を作成する: `/create-issue`
2. ブランチを作成する: `git checkout -b feat/xxx`
3. テストを作成する: `/create-test`
4. 実装する: `/implement-for-test`
5. コミットする: `/commit`
6. PRを作成する: `/create-pr`

🚀 開発を楽しんでください！
```

## 注意

- ユーザーの環境に応じて、適切なコマンドを案内してください
- エラーが発生した場合は、具体的な解決方法を提示してください
- 不明な点がある場合は、該当するドキュメントを参照するように案内してください
