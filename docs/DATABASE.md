# データベース設計ルール

このドキュメントでは、データベース設計における命名規則、ルール、ベストプラクティスを定義します。

---

## 技術スタック

**[`/init-project` を実行してデータベース技術スタックが設定されます]**

---

## テーブル命名規則

### 基本ルール

- **複数形を使用する** - `users`, `posts`, `comments`
- **小文字のスネークケース** - `user_profiles`, `blog_posts`
- **簡潔で明確な名前** - テーブルの内容が一目で分かる名前

### 良い例・悪い例

```
✅ 良い例:
- users
- blog_posts
- user_profiles
- order_items

❌ 悪い例:
- User (大文字)
- blogPost (キャメルケース)
- tbl_users (接頭辞不要)
- usr (略語)
```

### 中間テーブル（多対多）

2つのテーブル名をアルファベット順に並べて結合します。

```
users ←→ roles
中間テーブル名: user_roles

products ←→ categories
中間テーブル名: category_products
```

---

## カラム命名規則

### 基本ルール

- **小文字のスネークケース** - `first_name`, `created_at`
- **明確で分かりやすい名前**
- **真偽値は is_ / has_ を接頭辞に** - `is_active`, `has_permission`

### 良い例・悪い例

```
✅ 良い例:
- email
- first_name
- is_active
- created_at

❌ 悪い例:
- Email (大文字)
- firstName (キャメルケース)
- active (真偽値にis_なし)
- createdAt (キャメルケース)
```

---

## 必須カラム

すべてのテーブルには、以下のカラムを必ず含めてください。

### 主キー

```sql
id BIGINT AUTO_INCREMENT PRIMARY KEY
```

- **型**: `BIGINT` または `UUID`
- **AUTO_INCREMENT** または **UUID自動生成**

### タイムスタンプ

```sql
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

- **created_at**: レコード作成日時
- **updated_at**: レコード更新日時

---

## 論理削除

物理削除ではなく、論理削除を推奨します。

```sql
deleted_at TIMESTAMP NULL DEFAULT NULL
```

- **NULL**: 有効なレコード
- **TIMESTAMP**: 削除された日時

### 論理削除の実装例

```sql
-- 論理削除
UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE id = 1;

-- 有効なレコードのみ取得
SELECT * FROM users WHERE deleted_at IS NULL;
```

---

## データ型の選択

### 文字列

| 用途 | 型 | 説明 |
|-----|---|------|
| 短い文字列（255文字以内） | VARCHAR(255) | 名前、メールアドレス等 |
| 長い文字列 | TEXT | 説明文、コンテンツ等 |
| 固定長 | CHAR(N) | 郵便番号、固定長コード等 |

### 数値

| 用途 | 型 | 説明 |
|-----|---|------|
| 整数（小） | INT | 0 〜 約42億 |
| 整数（大） | BIGINT | 主キー、大きな数値 |
| 小数 | DECIMAL(M, D) | 金額、正確な小数 |
| 小数（概算） | FLOAT, DOUBLE | 科学計算（金額には使わない） |

### 日時

| 用途 | 型 | 説明 |
|-----|---|------|
| 日時 | TIMESTAMP | タイムゾーン考慮が必要な場合 |
| 日時 | DATETIME | タイムゾーン不要な場合 |
| 日付のみ | DATE | 誕生日等 |

### 真偽値

```sql
is_active BOOLEAN DEFAULT TRUE
```

- **MySQL**: `TINYINT(1)` として保存される
- **PostgreSQL**: `BOOLEAN` 型がある

### JSON

```sql
metadata JSON
```

- 構造化されていないデータを保存する場合に使用
- ただし、検索が必要なデータは正規化を推奨

---

## インデックス

### 基本ルール

- **主キーには自動的にインデックスが作成される**
- **外部キーにはインデックスを作成する**
- **WHERE句で頻繁に使われるカラムにはインデックスを作成する**
- **インデックスの作りすぎに注意**（書き込みパフォーマンスが低下）

### インデックスの命名規則

```
idx_<テーブル名>_<カラム名>
```

### インデックスの例

```sql
-- 単一カラムインデックス
CREATE INDEX idx_users_email ON users(email);

-- 複合インデックス
CREATE INDEX idx_posts_user_created ON posts(user_id, created_at);

-- ユニークインデックス
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);
```

### インデックスを作成すべきカラム

- ✅ 外部キー
- ✅ WHERE句で頻繁に使われるカラム
- ✅ ORDER BY / GROUP BYで使われるカラム
- ✅ JOINで使われるカラム
- ✅ ユニーク制約が必要なカラム

---

## 外部キー制約

### 基本ルール

- **外部キーには制約を設定する**
- **ON DELETE / ON UPDATEの動作を明示する**

### 外部キーの命名規則

```
fk_<テーブル名>_<参照先テーブル名>
```

### 外部キーの例

```sql
-- usersテーブルを参照
ALTER TABLE posts
ADD CONSTRAINT fk_posts_users
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

### ON DELETE / ON UPDATE の選択肢

| オプション | 説明 |
|----------|------|
| CASCADE | 親レコード削除時、子レコードも削除 |
| SET NULL | 親レコード削除時、子レコードの外部キーをNULLに |
| RESTRICT | 子レコードが存在する場合、親レコード削除不可 |
| NO ACTION | RESTRICTと同じ |

### 推奨設定

```sql
-- 論理削除を使う場合
ON DELETE RESTRICT  -- 物理削除を防ぐ

-- 物理削除を使う場合
ON DELETE CASCADE  -- 子レコードも削除
```

---

## ORM設定

**[`/init-project` で技術スタックに応じたORM設定が設定されます]**

### TypeORM（例）

```typescript
@Entity('users')
export class User {
  @PrimaryGeneratedColumn('increment')
  id: number;

  @Column({ type: 'varchar', length: 255 })
  email: string;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt: Date;
}
```

### Prisma（例）

```prisma
model User {
  id        BigInt    @id @default(autoincrement())
  email     String    @unique @db.VarChar(255)
  isActive  Boolean   @default(true)
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt
  deletedAt DateTime?
}
```

---

## マイグレーション

### 基本ルール

- **すべてのスキーマ変更はマイグレーションで管理する**
- **マイグレーションファイルは削除・編集しない**
- **ロールバック可能なマイグレーションを作成する**

### マイグレーションファイル命名規則

```
<タイムスタンプ>_<説明>.sql

例:
20240101120000_create_users_table.sql
20240102130000_add_email_to_users.sql
```

### マイグレーションの例

```sql
-- Up Migration
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL
);

CREATE INDEX idx_users_email ON users(email);

-- Down Migration
DROP TABLE IF EXISTS users;
```

---

## 正規化

### 基本原則

- **第3正規形までを推奨**
- **パフォーマンスが問題になる場合のみ非正規化を検討**

### 正規化の例

**❌ 悪い例（非正規化）**:

```
orders テーブル
+----+-----------+---------------+------------------+
| id | user_id   | user_name     | user_email       |
+----+-----------+---------------+------------------+
| 1  | 1         | John Doe      | john@example.com |
| 2  | 1         | John Doe      | john@example.com |
+----+-----------+---------------+------------------+
```

**✅ 良い例（正規化）**:

```
users テーブル
+----+-----------+------------------+
| id | name      | email            |
+----+-----------+------------------+
| 1  | John Doe  | john@example.com |
+----+-----------+------------------+

orders テーブル
+----+-----------+
| id | user_id   |
+----+-----------+
| 1  | 1         |
| 2  | 1         |
+----+-----------+
```

---

## セキュリティ

詳細は [SECURITY.md](SECURITY.md) を参照してください。

### SQLインジェクション対策

- **必ずORMまたはパラメータバインディングを使用する**
- **生のSQLを直接実行しない**

```typescript
// ❌ 悪い例：SQLインジェクションの危険性
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ 良い例：パラメータバインディング
const query = 'SELECT * FROM users WHERE email = ?';
db.query(query, [email]);
```

### 機密情報の保存

- **パスワードは必ずハッシュ化する**（bcrypt, argon2等）
- **個人情報は暗号化を検討する**
- **クレジットカード情報は保存しない**（トークン化を使用）

---

## パフォーマンス最適化

### N+1問題の回避

```typescript
// ❌ 悪い例：N+1問題
const users = await userRepository.find();
for (const user of users) {
  user.posts = await postRepository.findByUserId(user.id); // N回クエリ実行
}

// ✅ 良い例：Eager Loading
const users = await userRepository.find({
  relations: ['posts'], // 1回のクエリで取得
});
```

### SELECT文の最適化

```sql
-- ❌ 悪い例：不要なカラムを取得
SELECT * FROM users;

-- ✅ 良い例：必要なカラムのみ取得
SELECT id, email, name FROM users;
```

---

## バックアップとリストア

### バックアップ戦略

- **定期的な自動バックアップ**
- **本番環境は毎日バックアップ**
- **バックアップのリストアテストを定期的に実施**

---

## 禁止事項

- ❌ **テーブル名・カラム名にキャメルケースを使用**
- ❌ **予約語をテーブル名・カラム名に使用**（`user`, `order`等）
- ❌ **外部キー制約なしで関連を定義**
- ❌ **生のSQLを直接実行**（SQLインジェクションリスク）
- ❌ **パスワードの平文保存**

---

## 参考資料

- [ARCHITECTURE.md](ARCHITECTURE.md) - 設計方針
- [SECURITY.md](SECURITY.md) - セキュリティ設計
- [LOGGING.md](LOGGING.md) - ログ規約

---

## 更新履歴

- **[日付]**: `/init-project` でプロジェクト初期化
