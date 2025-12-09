# ログ出力規約

このドキュメントでは、ログ出力のルールとベストプラクティスを定義します。

---

## 基本方針

- **構造化ログ（JSON形式）を使用する**
- **ログレベルを適切に使い分ける**
- **機密情報をログに出力しない**
- **トレーサビリティを確保する**（trace_idの使用）

---

## ログ形式

### JSON形式（構造化ログ）

すべてのログは、以下のJSON形式で出力してください。

```json
{
  "timestamp": "2024-01-15T12:34:56.789Z",
  "level": "info",
  "event": "user_login_success",
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "12345",
  "ip_address": "192.168.1.1",
  "message": "User logged in successfully"
}
```

### 必須フィールド

すべてのログに以下のフィールドを含めてください。

| フィールド | 型 | 説明 |
|----------|---|------|
| `timestamp` | string (ISO 8601) | ログ出力日時 |
| `level` | string | ログレベル（debug, info, warn, error） |
| `event` | string | イベント名（動詞_名詞形式） |
| `trace_id` | string (UUID) | トレースID（リクエストごとに一意） |

### オプションフィールド

必要に応じて以下のフィールドを追加してください。

| フィールド | 型 | 説明 |
|----------|---|------|
| `user_id` | string | ユーザーID |
| `session_id` | string | セッションID |
| `ip_address` | string | IPアドレス |
| `user_agent` | string | ユーザーエージェント |
| `method` | string | HTTPメソッド（GET, POST等） |
| `path` | string | リクエストパス |
| `status_code` | number | HTTPステータスコード |
| `duration_ms` | number | 処理時間（ミリ秒） |
| `message` | string | 人間が読めるメッセージ |

---

## ログレベル

### レベル一覧

| レベル | 用途 | 例 |
|-------|------|---|
| `debug` | 開発時のデバッグ情報 | 変数の値、処理の流れ |
| `info` | 通常の動作情報 | ユーザーログイン、API呼び出し |
| `warn` | 警告（処理は継続） | 非推奨APIの使用、リトライ |
| `error` | エラー（処理失敗） | 例外発生、API呼び出し失敗 |

### レベルの使い分け

```typescript
// debug: 開発時のデバッグ情報
logger.debug('Processing user data', {
  event: 'user_data_processing',
  user_id: userId,
  data: userData,
});

// info: 通常の動作情報
logger.info('User logged in', {
  event: 'user_login_success',
  user_id: userId,
  ip_address: ipAddress,
});

// warn: 警告（処理は継続）
logger.warn('API rate limit approaching', {
  event: 'api_rate_limit_warning',
  current_count: 95,
  limit: 100,
});

// error: エラー（処理失敗）
logger.error('Failed to fetch user data', {
  event: 'user_fetch_failed',
  user_id: userId,
  error_type: 'DatabaseError',
  error_message: error.message,
});
```

---

## イベント命名規則

### 基本ルール

- **動詞_名詞形式**を使用する
- **小文字のスネークケース**
- **成功/失敗を明示する**（`_success` / `_failed`）

### 良い例・悪い例

```
✅ 良い例:
- user_login_success
- user_login_failed
- order_create_success
- payment_process_failed
- email_send_success

❌ 悪い例:
- userLogin (キャメルケース)
- login (名詞がない)
- user_login (成功/失敗が不明)
- LOGIN_SUCCESS (大文字)
```

### イベント名の例

| カテゴリ | 成功 | 失敗 |
|---------|------|------|
| 認証 | `user_login_success` | `user_login_failed` |
| 認証 | `user_logout_success` | - |
| ユーザー | `user_create_success` | `user_create_failed` |
| ユーザー | `user_update_success` | `user_update_failed` |
| ユーザー | `user_delete_success` | `user_delete_failed` |
| API | `api_call_success` | `api_call_failed` |
| DB | `db_query_success` | `db_query_failed` |
| メール | `email_send_success` | `email_send_failed` |

---

## エラーログの追加フィールド

エラーログには、以下のフィールドを必ず追加してください。

| フィールド | 型 | 説明 |
|----------|---|------|
| `error_type` | string | エラーの種類（クラス名） |
| `error_message` | string | エラーメッセージ |
| `stack_trace` | string | スタックトレース |
| `file` | string | エラー発生ファイル |
| `line` | number | エラー発生行 |
| `function` | string | エラー発生関数 |

### エラーログの例

```json
{
  "timestamp": "2024-01-15T12:34:56.789Z",
  "level": "error",
  "event": "user_fetch_failed",
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "12345",
  "error_type": "DatabaseError",
  "error_message": "Connection timeout",
  "stack_trace": "Error: Connection timeout\n    at Database.query (db.ts:45)\n    at UserRepository.findById (user.repository.ts:12)",
  "file": "user.repository.ts",
  "line": 12,
  "function": "findById"
}
```

---

## 具体例

### ユーザーログイン成功

```typescript
logger.info('User logged in successfully', {
  event: 'user_login_success',
  trace_id: req.headers['x-trace-id'],
  user_id: user.id,
  ip_address: req.ip,
  user_agent: req.headers['user-agent'],
});
```

```json
{
  "timestamp": "2024-01-15T12:34:56.789Z",
  "level": "info",
  "event": "user_login_success",
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "12345",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "message": "User logged in successfully"
}
```

### ユーザーログイン失敗

```typescript
logger.warn('User login failed due to invalid password', {
  event: 'user_login_failed',
  trace_id: req.headers['x-trace-id'],
  email: email, // 注意: メールアドレスは機密情報ではない
  ip_address: req.ip,
  reason: 'invalid_password',
});
```

```json
{
  "timestamp": "2024-01-15T12:34:56.789Z",
  "level": "warn",
  "event": "user_login_failed",
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "ip_address": "192.168.1.1",
  "reason": "invalid_password",
  "message": "User login failed due to invalid password"
}
```

### API呼び出し成功

```typescript
logger.info('API call completed', {
  event: 'api_call_success',
  trace_id: req.headers['x-trace-id'],
  method: req.method,
  path: req.path,
  status_code: 200,
  duration_ms: Date.now() - startTime,
  user_id: req.user?.id,
});
```

```json
{
  "timestamp": "2024-01-15T12:34:56.789Z",
  "level": "info",
  "event": "api_call_success",
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "method": "GET",
  "path": "/api/users/12345",
  "status_code": 200,
  "duration_ms": 45,
  "user_id": "12345"
}
```

### データベースエラー

```typescript
logger.error('Database query failed', {
  event: 'db_query_failed',
  trace_id: req.headers['x-trace-id'],
  query: 'SELECT * FROM users WHERE id = ?',
  error_type: error.constructor.name,
  error_message: error.message,
  stack_trace: error.stack,
  file: 'user.repository.ts',
  line: 45,
  function: 'findById',
});
```

```json
{
  "timestamp": "2024-01-15T12:34:56.789Z",
  "level": "error",
  "event": "db_query_failed",
  "trace_id": "550e8400-e29b-41d4-a716-446655440000",
  "query": "SELECT * FROM users WHERE id = ?",
  "error_type": "QueryFailedError",
  "error_message": "Connection timeout",
  "stack_trace": "Error: Connection timeout\n    at ...",
  "file": "user.repository.ts",
  "line": 45,
  "function": "findById"
}
```

---

## トレースID（trace_id）

### 目的

- **リクエストごとに一意のIDを付与**
- **複数のログを関連付ける**
- **問題の調査を容易にする**

### 実装方法

#### 1. ミドルウェアでトレースIDを生成

```typescript
import { v4 as uuidv4 } from 'uuid';

function traceIdMiddleware(req: Request, res: Response, next: NextFunction) {
  // クライアントから送られたトレースIDを使用、なければ生成
  req.headers['x-trace-id'] = req.headers['x-trace-id'] || uuidv4();
  next();
}
```

#### 2. すべてのログにトレースIDを含める

```typescript
logger.info('Processing request', {
  event: 'request_received',
  trace_id: req.headers['x-trace-id'],
});
```

#### 3. レスポンスヘッダーにトレースIDを含める

```typescript
res.setHeader('X-Trace-ID', req.headers['x-trace-id']);
```

---

## 機密情報の取り扱い

### ログに出力してはいけない情報

- ❌ **パスワード**
- ❌ **クレジットカード番号**
- ❌ **APIキー・トークン**
- ❌ **セッションID**（一部をマスキングする場合を除く）
- ❌ **個人を特定できる情報**（必要な場合はマスキング）

### マスキングの例

```typescript
// ❌ 悪い例：パスワードをログに出力
logger.debug('User data', { email, password });

// ✅ 良い例：パスワードは出力しない
logger.debug('User data', { email });

// ✅ 良い例：一部をマスキング
logger.info('Credit card added', {
  event: 'credit_card_add_success',
  card_last4: cardNumber.slice(-4),
});
```

---

## ログローテーション

### 基本方針

- **ログファイルが肥大化しないようにローテーションする**
- **古いログは圧縮・削除する**
- **本番環境では外部ログサービスを使用する**

### 推奨設定

- **ローテーション**: 毎日または1GB到達時
- **保持期間**: 30日間
- **圧縮**: gzip形式

---

## ログライブラリ

**[`/init-project` で技術スタックに応じたログライブラリが設定されます]**

### TypeScript / JavaScript

推奨ライブラリ:
- **Winston**
- **Pino**

### Python

推奨ライブラリ:
- **structlog**
- **python-json-logger**

---

## 禁止事項

- ❌ **console.log() を本番環境で使用**
- ❌ **機密情報をログに出力**
- ❌ **ログレベルを適切に使い分けない**
- ❌ **trace_idを付与しない**
- ❌ **構造化されていないログ**（プレーンテキストログ）

---

## 参考資料

- [ARCHITECTURE.md](ARCHITECTURE.md) - エラーハンドリング方針
- [SECURITY.md](SECURITY.md) - セキュリティ設計

---

## 更新履歴

- **[日付]**: `/init-project` でプロジェクト初期化
