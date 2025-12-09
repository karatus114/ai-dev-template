CLAUDE.md の「現状のAPI一覧」「現状のテーブル一覧」セクションを更新します。

## 重要

**「基本方針（変更禁止）」セクションは絶対に変更しないでください。**

## 更新対象セクション

### 1. 現状のAPI一覧（更新可能）

以下の形式で、実装済みのAPIエンドポイントを記載してください：

```markdown
## 現状のAPI一覧（更新可能）

**✅ このセクションはAIが更新できます。**

API実装時は、このセクションに追記してください。

### エンドポイント一覧

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

### 2. 現状のテーブル一覧（更新可能）

以下の形式で、作成済みのテーブルを記載してください：

```markdown
## 現状のテーブル一覧（更新可能）

**✅ このセクションはAIが更新できます。**

テーブル作成時は、このセクションに追記してください。

### データベーススキーマ

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

## 手順

### 1. 現在のコードを確認する

以下を確認してください：

#### APIエンドポイントの確認

- ルーティングファイルを確認
- Controllerファイルを確認
- 実装済みのエンドポイント一覧を取得

#### テーブルの確認

- マイグレーションファイルを確認
- エンティティ/モデルファイルを確認
- 作成済みのテーブル一覧を取得

### 2. CLAUDE.md を読み込む

現在の CLAUDE.md の内容を確認してください。

### 3. 該当セクションを更新する

**「現状のAPI一覧（更新可能）」**と**「現状のテーブル一覧（更新可能）」**のセクションのみを更新してください。

#### API一覧の更新例

```markdown
## 現状のAPI一覧（更新可能）

**✅ このセクションはAIが更新できます。**

### エンドポイント一覧

## 認証

### POST /api/auth/login
- **概要**: ユーザーログイン
- **認証**: 不要
- **リクエスト**:
  ```json
  {
    "email": "user@example.com",
    "password": "Password123"
  }
  ```
- **レスポンス**:
  - 成功: 200 OK
    ```json
    {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
    ```
  - エラー: 401 Unauthorized

### POST /api/auth/logout
- **概要**: ユーザーログアウト
- **認証**: 必要
- **リクエスト**: なし
- **レスポンス**:
  - 成功: 200 OK

## ユーザー

### GET /api/users
- **概要**: ユーザー一覧取得
- **認証**: 必要
- **リクエスト**:
  - クエリパラメータ:
    - `page` (number): ページ番号（デフォルト: 1）
    - `limit` (number): 取得件数（デフォルト: 20）
    - `search` (string): 検索キーワード（オプション）
- **レスポンス**:
  - 成功: 200 OK
    ```json
    {
      "users": [...],
      "pagination": {
        "total": 100,
        "page": 1,
        "limit": 20,
        "totalPages": 5
      }
    }
    ```

### GET /api/users/:id
- **概要**: 特定ユーザー取得
- **認証**: 必要
- **リクエスト**: なし
- **レスポンス**:
  - 成功: 200 OK
  - エラー: 404 Not Found

### POST /api/users
- **概要**: ユーザー作成
- **認証**: 必要（管理者のみ）
- **リクエスト**:
  ```json
  {
    "email": "user@example.com",
    "password": "Password123",
    "name": "John Doe"
  }
  ```
- **レスポンス**:
  - 成功: 201 Created
  - エラー: 400 Bad Request, 409 Conflict
```

#### テーブル一覧の更新例

```markdown
## 現状のテーブル一覧（更新可能）

**✅ このセクションはAIが更新できます。**

### データベーススキーマ

## テーブル名: users

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | NO | AUTO_INCREMENT | 主キー |
| email | varchar(255) | NO | - | メールアドレス |
| password | varchar(255) | NO | - | パスワード（ハッシュ化） |
| name | varchar(255) | NO | - | 名前 |
| is_active | boolean | NO | TRUE | アクティブフラグ |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP | 更新日時 |
| deleted_at | timestamp | YES | NULL | 削除日時（論理削除） |

**インデックス**:
- PRIMARY KEY (id)
- UNIQUE INDEX idx_users_email (email)
- INDEX idx_users_deleted_at (deleted_at)

**外部キー**:
- なし

---

## テーブル名: posts

| カラム名 | 型 | NULL | デフォルト | 説明 |
|---------|-----|------|-----------|------|
| id | bigint | NO | AUTO_INCREMENT | 主キー |
| user_id | bigint | NO | - | ユーザーID |
| title | varchar(255) | NO | - | タイトル |
| content | text | NO | - | 本文 |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | 作成日時 |
| updated_at | timestamp | NO | CURRENT_TIMESTAMP | 更新日時 |
| deleted_at | timestamp | YES | NULL | 削除日時（論理削除） |

**インデックス**:
- PRIMARY KEY (id)
- INDEX idx_posts_user_id (user_id)
- INDEX idx_posts_created_at (created_at)

**外部キー**:
- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
```

### 4. CLAUDE.md を保存する

更新した内容で CLAUDE.md を保存してください。

## 出力メッセージ

更新完了後、以下のメッセージを表示してください：

```
✅ CLAUDE.md が更新されました！

📝 更新されたセクション:
- 現状のAPI一覧
- 現状のテーブル一覧

📊 更新内容:
- API エンドポイント: X件
- テーブル: Y件

🚀 次のステップ:
1. 更新内容を確認してください
2. 必要に応じてコミットしてください
   \`\`\`
   /commit
   \`\`\`
```

## 注意

- **「基本方針（変更禁止）」セクションは絶対に変更しないでください**
- 「現状のAPI一覧（更新可能）」と「現状のテーブル一覧（更新可能）」のみを更新してください
- 既存の内容を上書きする場合は、ユーザーに確認してください
- docs/ARCHITECTURE.md や docs/DATABASE.md も併せて更新することを推奨します

## 参考資料

- [CLAUDE.md](../CLAUDE.md) - Claude Code固有の設定
- [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) - 設計方針
- [docs/DATABASE.md](../docs/DATABASE.md) - DB設計ルール
