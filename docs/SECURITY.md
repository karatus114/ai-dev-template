# セキュリティ設計・対策

このドキュメントでは、セキュリティに関する設計方針と対策を定義します。

---

## 基本方針

- **セキュリティファースト** - すべての実装でセキュリティを最優先する
- **入力は信用しない** - すべての入力を検証する
- **最小権限の原則** - 必要最小限の権限のみを付与する
- **多層防御** - 複数のセキュリティ対策を組み合わせる

---

## 入力検証（バリデーション）

### 基本ルール

- **すべての入力を検証する**
- **クライアント側とサーバー側の両方で検証する**
- **バリデーションライブラリを使用する**（手動実装しない）

### 推奨ライブラリ

**[`/init-project` で技術スタックに応じたバリデーションライブラリが設定されます]**

#### TypeScript / JavaScript
- **Zod**
- **Yup**
- **Joi**

#### Python
- **Pydantic**
- **Marshmallow**

### 実装例

**TypeScript（Zod）**:

```typescript
import { z } from 'zod';

// スキーマ定義
const userSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .regex(/[A-Z]/, 'Password must contain uppercase letter')
    .regex(/[a-z]/, 'Password must contain lowercase letter')
    .regex(/[0-9]/, 'Password must contain number'),
  age: z.number().int().min(0).max(150),
});

// バリデーション
try {
  const validatedData = userSchema.parse(requestData);
} catch (error) {
  if (error instanceof z.ZodError) {
    throw new ValidationError('Invalid input', error.errors);
  }
}
```

**Python（Pydantic）**:

```python
from pydantic import BaseModel, EmailStr, Field, validator

class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8)
    age: int = Field(..., ge=0, le=150)

    @validator('password')
    def password_strength(cls, v):
        if not any(c.isupper() for c in v):
            raise ValueError('Password must contain uppercase letter')
        if not any(c.islower() for c in v):
            raise ValueError('Password must contain lowercase letter')
        if not any(c.isdigit() for c in v):
            raise ValueError('Password must contain number')
        return v

# バリデーション
try:
    user = UserCreate(**request_data)
except ValidationError as e:
    raise HTTPException(status_code=400, detail=e.errors())
```

### 検証項目

| 項目 | 検証内容 |
|-----|---------|
| 型 | 文字列、数値、真偽値等の型チェック |
| 長さ | 最小・最大長の制限 |
| 形式 | メールアドレス、URL、電話番号等の形式チェック |
| 範囲 | 数値の最小・最大値 |
| 必須 | 必須項目のチェック |
| 許可リスト | 許可された値のみを受け入れる |

---

## 認証（Authentication）

### パスワード管理

#### パスワードのハッシュ化

**必ずbcryptまたはargon2を使用してください。**

```typescript
import bcrypt from 'bcrypt';

// パスワードのハッシュ化
const saltRounds = 10;
const hashedPassword = await bcrypt.hash(password, saltRounds);

// パスワードの検証
const isValid = await bcrypt.compare(password, hashedPassword);
```

```python
import bcrypt

# パスワードのハッシュ化
salt = bcrypt.gensalt()
hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)

# パスワードの検証
is_valid = bcrypt.checkpw(password.encode('utf-8'), hashed_password)
```

#### パスワードポリシー

- **最小8文字以上**
- **大文字・小文字・数字を含む**
- **特殊文字を含むことを推奨**

### JWT（JSON Web Token）

#### JWT設定

```typescript
import jwt from 'jsonwebtoken';

// トークン生成
const token = jwt.sign(
  { userId: user.id, email: user.email },
  process.env.JWT_SECRET,
  { expiresIn: '1h' }
);

// トークン検証
try {
  const decoded = jwt.verify(token, process.env.JWT_SECRET);
} catch (error) {
  throw new UnauthorizedError('Invalid token');
}
```

#### JWT設定のベストプラクティス

- **JWT_SECRETは環境変数で管理**（.envファイル）
- **強力なシークレットキーを使用**（最低32文字、ランダムな文字列）
- **有効期限を設定**（1時間〜24時間を推奨）
- **リフレッシュトークンを使用**（長期間のセッション管理）

### セッション管理

- **HttpOnly Cookieを使用**（XSS対策）
- **Secure属性を設定**（HTTPS通信のみ）
- **SameSite属性を設定**（CSRF対策）

```typescript
res.cookie('token', token, {
  httpOnly: true,  // JavaScriptからアクセス不可
  secure: true,    // HTTPS通信のみ
  sameSite: 'strict',  // CSRF対策
  maxAge: 3600000, // 1時間
});
```

---

## 認可（Authorization）

### 基本ルール

- **認証後、必ず認可チェックを行う**
- **リソースごとにアクセス権限を確認する**

### 実装例

```typescript
// ミドルウェアで認可チェック
async function checkPermission(req: Request, res: Response, next: NextFunction) {
  const userId = req.user.id;
  const resourceId = req.params.id;

  const resource = await resourceRepository.findById(resourceId);
  if (!resource) {
    throw new NotFoundError('Resource not found');
  }

  // リソースの所有者かどうかチェック
  if (resource.userId !== userId) {
    throw new ForbiddenError('Access denied');
  }

  next();
}
```

---

## SQLインジェクション対策

### 基本ルール

- **必ずORMまたはパラメータバインディングを使用する**
- **生のSQLを直接実行しない**

### 悪い例・良い例

```typescript
// ❌ 悪い例：SQLインジェクションの危険性
const query = `SELECT * FROM users WHERE email = '${email}'`;
db.query(query);

// ✅ 良い例：パラメータバインディング
const query = 'SELECT * FROM users WHERE email = ?';
db.query(query, [email]);

// ✅ 良い例：ORM使用
const user = await userRepository.findOne({ where: { email } });
```

---

## XSS（クロスサイトスクリプティング）対策

### 基本ルール

- **ユーザー入力を必ずエスケープする**
- **innerHTML等の危険なAPIを避ける**
- **Content-Security-Policyヘッダーを設定する**

### 実装例

**フロントエンド（React）**:

```typescript
// ✅ 良い例：Reactが自動でエスケープ
<div>{user.name}</div>

// ❌ 悪い例：dangerouslySetInnerHTMLは避ける
<div dangerouslySetInnerHTML={{ __html: user.name }} />

// ✅ 例外的に使う場合：DOMPurifyでサニタイズ
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(html) }} />
```

**バックエンド（Express）**:

```typescript
import helmet from 'helmet';

app.use(helmet());  // セキュリティヘッダーを自動設定

// Content-Security-Policy設定
app.use(
  helmet.contentSecurityPolicy({
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
    },
  })
);
```

---

## CSRF（クロスサイトリクエストフォージェリ）対策

### 基本ルール

- **SameSite Cookieを使用する**
- **CSRFトークンを使用する**

### 実装例

```typescript
import csrf from 'csurf';

// CSRF保護ミドルウェア
const csrfProtection = csrf({ cookie: true });
app.use(csrfProtection);

// フォームにCSRFトークンを埋め込む
app.get('/form', (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});
```

---

## 機密情報の管理

### 環境変数の使用

**すべての機密情報は環境変数で管理してください。**

```bash
# .env（Gitにコミットしない）
DATABASE_URL=postgresql://user:password@localhost:5432/db
JWT_SECRET=your-super-secret-key-here
API_KEY=your-api-key-here
```

```typescript
// コード内で環境変数を使用
const dbUrl = process.env.DATABASE_URL;
const jwtSecret = process.env.JWT_SECRET;
```

### ハードコード禁止

以下の情報は**絶対にハードコードしないでください**。

- ❌ パスワード
- ❌ APIキー
- ❌ トークン
- ❌ シークレットキー
- ❌ データベース接続情報
- ❌ クレジットカード情報

### Gitにコミットしてはいけないもの

以下のファイル・情報は、`.gitignore`に追加してGitにコミットしないでください。

- `.env`, `.env.local`, `.env.*.local`
- `*.pem`, `*.key`, `*.p12`
- `credentials.json`, `service-account.json`
- `secrets/` ディレクトリ

詳細は [.gitignore](.gitignore) を参照してください。

---

## ファイルアップロードの制限

### 基本ルール

- **ファイルサイズを制限する**
- **許可するファイル形式を制限する**
- **ファイル名をサニタイズする**
- **アップロード先をドキュメントルート外に配置する**

### 実装例

```typescript
import multer from 'multer';
import path from 'path';

// ファイルアップロード設定
const upload = multer({
  storage: multer.diskStorage({
    destination: '/var/uploads/', // ドキュメントルート外
    filename: (req, file, cb) => {
      // ファイル名をサニタイズ
      const sanitizedName = `${Date.now()}-${file.originalname.replace(/[^a-zA-Z0-9.-]/g, '')}`;
      cb(null, sanitizedName);
    },
  }),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
  },
  fileFilter: (req, file, cb) => {
    // 許可するファイル形式
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'));
    }
  },
});
```

---

## APIセキュリティ

### レート制限

**DDoS攻撃や総当たり攻撃を防ぐため、レート制限を実装してください。**

```typescript
import rateLimit from 'express-rate-limit';

// レート制限設定
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分
  max: 100, // 最大100リクエスト
  message: 'Too many requests from this IP',
});

app.use('/api/', limiter);

// ログインエンドポイントはより厳しく
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分
  max: 5, // 最大5回
  message: 'Too many login attempts',
});

app.use('/api/auth/login', loginLimiter);
```

### CORS設定

```typescript
import cors from 'cors';

// CORS設定
app.use(
  cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || 'http://localhost:3000',
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);
```

### HTTPSの強制

```typescript
// HTTPSリダイレクト
app.use((req, res, next) => {
  if (req.header('x-forwarded-proto') !== 'https') {
    res.redirect(`https://${req.header('host')}${req.url}`);
  } else {
    next();
  }
});
```

---

## エラーメッセージ

### 機密情報を含めない

エラーメッセージには、以下の情報を**絶対に含めないでください**。

- ❌ パスワード
- ❌ APIキー
- ❌ データベース接続情報
- ❌ 内部パス
- ❌ スタックトレース（本番環境）

### 良い例・悪い例

```typescript
// ❌ 悪い例：内部情報が漏洩
res.status(500).json({
  error: 'Database connection failed: postgresql://user:password@localhost:5432/db',
});

// ✅ 良い例：一般的なメッセージ
res.status(500).json({
  error: 'Internal server error',
  trace_id: traceId, // トレースIDのみ返す
});
```

---

## AIコード生成時のレビュー観点

AIがコードを生成した場合、以下の観点で**必ずレビュー**してください。

### チェックリスト

- [ ] **入力検証が実装されているか**
- [ ] **SQLインジェクション対策がされているか**（ORM使用、パラメータバインディング）
- [ ] **XSS対策がされているか**（ユーザー入力のエスケープ）
- [ ] **機密情報がハードコードされていないか**
- [ ] **認証・認可が適切に実装されているか**
- [ ] **エラーメッセージに機密情報が含まれていないか**
- [ ] **ファイルアップロードに制限があるか**
- [ ] **レート制限が設定されているか**（必要に応じて）

### `/code-review` コマンドの使用

Claude Codeを使用している場合は、`/code-review` コマンドでセキュリティレビューを実施できます。

```
/code-review
```

---

## 定期的なセキュリティチェック

### 脆弱性スキャン

定期的に依存関係の脆弱性をチェックしてください。

```bash
# npm
npm audit

# Pythonp
pip-audit
```

### セキュリティアップデート

依存関係は定期的に更新してください。

```bash
# npm
npm update

# Python
pip install --upgrade -r requirements.txt
```

---

## 禁止事項

- ❌ **パスワードの平文保存**
- ❌ **機密情報のハードコード**
- ❌ **入力検証の省略**
- ❌ **生のSQL実行**
- ❌ **エラーメッセージへの機密情報の含有**
- ❌ **HTTPSなしでの機密情報の送信**
- ❌ **セッションIDのURLへの含有**

---

## 参考資料

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [ARCHITECTURE.md](ARCHITECTURE.md) - 設計方針
- [DATABASE.md](DATABASE.md) - DB設計ルール
- [LOGGING.md](LOGGING.md) - ログ規約

---

## 更新履歴

- **[日付]**: ドキュメント作成
