# 設計方針・アーキテクチャ

このドキュメントでは、プロジェクトの設計方針とアーキテクチャを定義します。

---

## 全体構成

**[`/init-project` を実行してアーキテクチャ構成が設定されます]**

---

## レイヤー構成

このプロジェクトでは、責務を明確に分離するために以下のレイヤー構成を採用します。

```
┌─────────────────────────────────────┐
│      Controller / Handler          │ ← リクエスト受付・レスポンス返却
├─────────────────────────────────────┤
│         Service                    │ ← ビジネスロジック
├─────────────────────────────────────┤
│       Repository / DAO             │ ← データアクセス
├─────────────────────────────────────┤
│         Database                   │ ← データ永続化
└─────────────────────────────────────┘
```

### Controller / Handler 層

**責務**:

- HTTPリクエストの受け取り
- 入力検証（バリデーション）
- Service層の呼び出し
- HTTPレスポンスの返却
- エラーハンドリング（HTTPステータスコードへの変換）

**禁止事項**:

- ❌ ビジネスロジックの実装
- ❌ 直接的なデータベースアクセス
- ❌ 複雑な計算処理

**例**:

```typescript
// ✅ 良い例
async function getUser(req: Request, res: Response) {
  try {
    // 入力検証
    const userId = validateUserId(req.params.id);

    // Service層を呼び出す
    const user = await userService.findById(userId);

    // レスポンス返却
    res.json({ user });
  } catch (error) {
    handleError(error, res);
  }
}

// ❌ 悪い例：ビジネスロジックがControllerに含まれている
async function getUser(req: Request, res: Response) {
  const user = await db.users.findOne({ id: req.params.id });
  if (!user.isActive) {
    user.lastAccess = new Date();
    await db.users.update(user);
  }
  res.json({ user });
}
```

### Service 層

**責務**:

- ビジネスロジックの実装
- トランザクション管理
- 複数のRepositoryの組み合わせ
- ビジネスルールの適用

**禁止事項**:

- ❌ HTTPリクエスト/レスポンスへの直接アクセス
- ❌ 直接的なSQL実行（Repositoryを経由する）

**例**:

```typescript
// ✅ 良い例
class UserService {
  async createUser(userData: CreateUserDto): Promise<User> {
    // ビジネスルールの適用
    if (await this.userRepository.existsByEmail(userData.email)) {
      throw new ConflictError('Email already exists');
    }

    // パスワードのハッシュ化（セキュリティ処理）
    const hashedPassword = await bcrypt.hash(userData.password, 10);

    // Repository経由でデータ保存
    const user = await this.userRepository.create({
      ...userData,
      password: hashedPassword,
    });

    // 他のサービスとの連携
    await this.emailService.sendWelcomeEmail(user.email);

    return user;
  }
}
```

### Repository / DAO 層

**責務**:

- データベースアクセスの抽象化
- CRUD操作の実装
- クエリの構築
- ORMの利用

**禁止事項**:

- ❌ ビジネスロジックの実装
- ❌ 他のRepositoryの呼び出し

**例**:

```typescript
// ✅ 良い例
class UserRepository {
  async findById(id: string): Promise<User | null> {
    return await db.users.findOne({ where: { id } });
  }

  async existsByEmail(email: string): Promise<boolean> {
    const count = await db.users.count({ where: { email } });
    return count > 0;
  }

  async create(userData: Partial<User>): Promise<User> {
    return await db.users.create(userData);
  }
}
```

---

## 状態管理方針（フロントエンド）

**[`/init-project` で技術スタックに応じた状態管理方針が設定されます]**

### 基本原則

- **グローバル状態は最小限にする**
- **コンポーネントローカルな状態はコンポーネント内に持つ**
- **サーバー状態とクライアント状態を明確に分ける**

---

## エラーハンドリング方針

### エラーの種類

以下のようにエラーを分類し、適切に処理します。

| エラー種別 | HTTPステータス | 説明 |
|----------|--------------|------|
| ValidationError | 400 Bad Request | 入力検証エラー |
| UnauthorizedError | 401 Unauthorized | 認証エラー |
| ForbiddenError | 403 Forbidden | 認可エラー |
| NotFoundError | 404 Not Found | リソースが存在しない |
| ConflictError | 409 Conflict | リソースの競合 |
| InternalServerError | 500 Internal Server Error | サーバー内部エラー |

### エラーハンドリングの流れ

```
1. エラー発生
   ↓
2. 適切なエラークラスでthrow
   ↓
3. Service層でキャッチ（必要に応じて）
   ↓
4. Controller層でキャッチ
   ↓
5. HTTPステータスコードに変換
   ↓
6. ログ出力（LOGGING.md参照）
   ↓
7. クライアントにレスポンス返却
```

### エラーレスポンスの形式

```json
{
  "error": {
    "type": "ValidationError",
    "message": "Invalid email format",
    "details": [
      {
        "field": "email",
        "message": "Email must be a valid email address"
      }
    ],
    "trace_id": "550e8400-e29b-41d4-a716-446655440000"
  }
}
```

### エラーハンドリングの実装例

**TypeScript**:

```typescript
// カスタムエラークラス
class ValidationError extends Error {
  constructor(message: string, public details?: any[]) {
    super(message);
    this.name = 'ValidationError';
  }
}

// グローバルエラーハンドラー（Express）
function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  const traceId = req.headers['x-trace-id'] || generateTraceId();

  // ログ出力
  logger.error('Request failed', {
    event: 'request_failed',
    trace_id: traceId,
    error_type: err.constructor.name,
    error_message: err.message,
    stack_trace: err.stack,
  });

  // HTTPステータスコードの決定
  let statusCode = 500;
  if (err instanceof ValidationError) statusCode = 400;
  if (err instanceof UnauthorizedError) statusCode = 401;
  if (err instanceof NotFoundError) statusCode = 404;

  // レスポンス返却
  res.status(statusCode).json({
    error: {
      type: err.constructor.name,
      message: err.message,
      details: (err as any).details,
      trace_id: traceId,
    },
  });
}
```

---

## トランザクション管理

### 基本原則

- **Service層でトランザクションを管理する**
- **トランザクションは可能な限り短く保つ**
- **デッドロックに注意する**

### 実装例

**TypeScript（TypeORM）**:

```typescript
class UserService {
  async createUserWithProfile(userData: CreateUserDto): Promise<User> {
    return await this.dataSource.transaction(async (manager) => {
      // トランザクション内でユーザー作成
      const user = await manager.save(User, userData);

      // トランザクション内でプロフィール作成
      await manager.save(Profile, {
        userId: user.id,
        ...userData.profile,
      });

      return user;
    });
  }
}
```

---

## 依存性注入（DI）

**[`/init-project` で技術スタックに応じたDI方針が設定されます]**

### 基本原則

- **コンストラクタインジェクションを使用する**
- **インターフェースに依存する（実装に依存しない）**
- **テストしやすい設計にする**

---

## APIデザイン

### RESTful API

以下のRESTful原則に従います。

| HTTPメソッド | 用途 | エンドポイント例 | 説明 |
|------------|------|----------------|------|
| GET | 取得 | GET /api/users | ユーザー一覧取得 |
| GET | 取得 | GET /api/users/:id | 特定ユーザー取得 |
| POST | 作成 | POST /api/users | ユーザー作成 |
| PUT | 更新 | PUT /api/users/:id | ユーザー全体更新 |
| PATCH | 部分更新 | PATCH /api/users/:id | ユーザー部分更新 |
| DELETE | 削除 | DELETE /api/users/:id | ユーザー削除 |

### バージョニング

APIバージョンは、URLに含めるか、ヘッダーで指定します。

```
# URL versioning
/api/v1/users
/api/v2/users

# Header versioning
Accept: application/vnd.api+json; version=1
```

### ページネーション

リスト取得APIには、ページネーションを実装します。

```
GET /api/users?page=1&limit=20

Response:
{
  "data": [...],
  "pagination": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  }
}
```

---

## セキュリティアーキテクチャ

詳細は [SECURITY.md](SECURITY.md) を参照してください。

### 認証フロー

```
1. クライアント: POST /api/auth/login
   ↓
2. サーバー: 認証情報検証
   ↓
3. サーバー: JWTトークン生成
   ↓
4. クライアント: トークンを保存（HttpOnly Cookie or LocalStorage）
   ↓
5. クライアント: 以降のリクエストにトークンを含める
   ↓
6. サーバー: ミドルウェアでトークン検証
```

---

## パフォーマンス最適化

### データベースクエリ

- **N+1問題の回避**（eager loadingを使用）
- **適切なインデックスの設定**（[DATABASE.md](DATABASE.md) 参照）
- **不要なデータの取得を避ける**（SELECT * を避ける）

### キャッシング

**[`/init-project` で技術スタックに応じたキャッシング方針が設定されます]**

---

## テスタビリティ

詳細は [TESTING.md](TESTING.md) を参照してください。

### テストしやすい設計

- **依存性注入を使用する**
- **モックしやすいインターフェースを定義する**
- **副作用を最小限にする**

---

## 禁止事項

- ❌ レイヤーをスキップする（ControllerからRepository直接呼び出し等）
- ❌ 循環依存
- ❌ グローバル変数の多用
- ❌ ビジネスロジックのController層への記述

---

## 参考資料

- [CODING_RULES.md](CODING_RULES.md) - コード規約
- [DATABASE.md](DATABASE.md) - DB設計ルール
- [SECURITY.md](SECURITY.md) - セキュリティ設計
- [TESTING.md](TESTING.md) - テスト方針

---

## 更新履歴

- **[日付]**: `/init-project` でプロジェクト初期化
