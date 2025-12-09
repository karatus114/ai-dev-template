プロジェクトの初期設定を行います。

## 手順

### 1. 技術スタックの選択（対話形式）

以下の質問を順番にユーザーに投げかけ、回答を記録してください。

#### フロントエンド

どのフロントエンド技術を使用しますか？

1. React + TypeScript
2. Next.js
3. Vue.js
4. なし（APIのみ）
5. その他（手動入力）

#### バックエンド

どのバックエンド技術を使用しますか？

1. FastAPI (Python)
2. Express (Node.js)
3. NestJS (Node.js)
4. Spring Boot (Java/Kotlin)
5. Go
6. なし（フロントのみ）
7. その他（手動入力）

#### データベース

どのデータベースを使用しますか？

1. PostgreSQL
2. MySQL
3. MongoDB
4. SQLite
5. なし
6. その他（手動入力）

### 2. 選択に応じてドキュメントを更新

以下のファイルを技術スタックに応じて更新してください：

#### AGENTS.md

- **プロジェクト概要**セクション
  - プロジェクト名、説明を記載

- **技術スタック**セクション
  - 選択した技術を記載
  - フロントエンド、バックエンド、データベースを明記

- **セットアップコマンド**セクション
  - 技術スタックに応じたセットアップコマンドを記載
  - 例：`npm install`、`pip install -r requirements.txt`

#### docs/CODING_RULES.md

- **命名規則**セクション
  - 言語別の命名規則（キャメルケース、スネークケース等）
  - ファイル命名規則

- **ディレクトリ構成**セクション
  - 技術スタックに応じたディレクトリ構成
  - 例：React: `src/components/`, Python: `app/`

- **リンター・フォーマッター設定**セクション
  - ESLint, Prettier（JavaScript/TypeScript）
  - Black, Flake8（Python）
  - 設定ファイルの生成

#### docs/ARCHITECTURE.md

- **全体構成**セクション
  - 技術スタックの全体像

- **レイヤー構成**セクション
  - 技術スタックに応じた実装例

- **状態管理方針**セクション（フロントエンド）
  - Redux, Context API, Zustand等

- **依存性注入**セクション
  - DI方針（NestJS, Spring Boot等）

- **キャッシング方針**セクション
  - Redis, メモリキャッシュ等

#### docs/DATABASE.md

- **技術スタック**セクション
  - 選択したデータベース

- **ORM設定**セクション
  - TypeORM, Prisma（TypeScript）
  - SQLAlchemy（Python）
  - 設定例とエンティティ定義例

#### docs/TESTING.md

- **テストファイル命名規則**セクション
  - 言語別の命名規則

- **テストフレームワーク**セクション
  - Jest, Vitest（JavaScript/TypeScript）
  - pytest（Python）
  - 設定ファイルの生成

### 3. 必要なファイルの雛形を生成（オプション）

以下の作業を実施するか、ユーザーに確認してください：

#### ディレクトリ構成の作成

技術スタックに応じたディレクトリを作成：

**React + Express + PostgreSQL の例**:
```
src/
├── components/
├── pages/
├── services/
├── utils/
server/
├── controllers/
├── services/
├── repositories/
├── models/
tests/
```

**FastAPI + React の例**:
```
frontend/
├── src/
│   ├── components/
│   ├── pages/
│   ├── services/
backend/
├── app/
│   ├── api/
│   ├── services/
│   ├── repositories/
│   ├── models/
tests/
```

#### 設定ファイルの生成

以下のファイルを生成：

**TypeScript/JavaScript**:
- `package.json`
- `tsconfig.json`
- `.eslintrc.js`
- `.prettierrc`

**Python**:
- `requirements.txt`
- `pyproject.toml`
- `.flake8`

**データベース**:
- マイグレーションディレクトリ
- ORM設定ファイル

## 注意

- **このコマンドは原則1回のみ実行**してください
- 技術スタックの変更が必要な場合は、再実行可能です
- 既存のドキュメントの内容を上書きする場合は、ユーザーに確認してください

## 完了メッセージ

すべての設定が完了したら、以下のメッセージを表示してください：

```
✅ プロジェクトの初期設定が完了しました！

📋 技術スタック:
- フロントエンド: [選択した技術]
- バックエンド: [選択した技術]
- データベース: [選択した技術]

📝 更新されたドキュメント:
- AGENTS.md
- docs/CODING_RULES.md
- docs/ARCHITECTURE.md
- docs/DATABASE.md
- docs/TESTING.md

🚀 次のステップ:
1. 依存関係をインストールしてください: [コマンド]
2. .env ファイルを作成してください: cp .env.example .env
3. .env ファイルを編集して、必要な環境変数を設定してください
4. 開発を開始してください！

💡 利用可能なコマンド:
- /setup - 新規参画者向けセットアップ
- /create-test - テスト作成
- /implement-for-test - 実装
- /code-review - コードレビュー
- /commit - コミット
- /create-pr - PR作成
```
