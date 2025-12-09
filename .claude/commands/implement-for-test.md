テストに対する実装を作成します。

## 重要

- **テストを変更しないでください**
- **テストがすべてパスするまで修正を繰り返してください**
- **モック実装やハードコードは禁止です**

## 手順

### 1. テストを確認する

以下の情報を確認してください：

- どのテストファイルが対象か
- テストで何が期待されているか
- 正常系、異常系、境界値のテストケース

### 2. 実装を作成する

#### 基本方針

- **テストがパスする最小限の実装を行う**
- **docs/ のルールに従う**
  - [CODING_RULES.md](../docs/CODING_RULES.md) - コード規約
  - [ARCHITECTURE.md](../docs/ARCHITECTURE.md) - レイヤー構成
  - [SECURITY.md](../docs/SECURITY.md) - セキュリティ対策
  - [LOGGING.md](../docs/LOGGING.md) - ログ出力

#### 実装の流れ

1. **型定義・インターフェース**を作成（必要に応じて）
2. **Service層**の実装
3. **Repository層**の実装（必要に応じて）
4. **Controller層**の実装（APIの場合）

#### 例（TypeScript）

**Service層**:

```typescript
import bcrypt from 'bcrypt';
import { z } from 'zod';
import { UserRepository } from '@/repositories/UserRepository';
import { ValidationError, ConflictError } from '@/errors';
import type { User, CreateUserDto } from '@/types';

// バリデーションスキーマ
const createUserSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
});

export class UserService {
  constructor(private userRepository: UserRepository) {}

  async create(userData: CreateUserDto): Promise<User> {
    // 入力検証
    const validatedData = createUserSchema.parse(userData);

    // メールアドレスの重複チェック
    const existingUser = await this.userRepository.findByEmail(validatedData.email);
    if (existingUser) {
      throw new ConflictError('Email already exists');
    }

    // パスワードのハッシュ化
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(validatedData.password, saltRounds);

    // ユーザー作成
    const user = await this.userRepository.create({
      ...validatedData,
      password: hashedPassword,
    });

    return user;
  }
}
```

**Repository層**:

```typescript
import { db } from '@/db';
import type { User, CreateUserDto } from '@/types';

export class UserRepository {
  async findByEmail(email: string): Promise<User | null> {
    return await db.users.findOne({ where: { email } });
  }

  async create(userData: Partial<User>): Promise<User> {
    return await db.users.create(userData);
  }
}
```

### 3. テストを実行する

実装が完了したら、テストを実行してください：

```bash
# TypeScript / JavaScript
npm test

# Python
pytest
```

### 4. テストがパスするまで修正を繰り返す

- すべてのテストがパスするまで修正を繰り返してください
- エラーメッセージを確認し、原因を特定してください
- 不明な場合は、docs/ のドキュメントを参照してください

### 5. コードレビュー（推奨）

テストがパスしたら、自己レビューを実施してください：

```
/code-review
```

## 禁止事項

### ❌ テストを変更する

```typescript
// ❌ 悪い例：テストを変更してパスさせる
it('should throw ValidationError when password is less than 8 characters', async () => {
  // テストを緩くする
  await expect(userService.create({ password: 'Pass1' })).rejects.toThrow(ValidationError);
});
```

### ❌ モック実装やハードコード

```typescript
// ❌ 悪い例：モック実装
async create(userData: CreateUserDto): Promise<User> {
  return {
    id: 1,
    email: 'test@example.com',
    password: 'hashed',
  };
}

// ✅ 良い例：実際の実装
async create(userData: CreateUserDto): Promise<User> {
  const validatedData = createUserSchema.parse(userData);
  const hashedPassword = await bcrypt.hash(validatedData.password, 10);
  return await this.userRepository.create({
    ...validatedData,
    password: hashedPassword,
  });
}
```

### ❌ セキュリティ対策を省略する

```typescript
// ❌ 悪い例：入力検証なし
async create(userData: any): Promise<User> {
  return await this.userRepository.create(userData);
}

// ✅ 良い例：入力検証あり
async create(userData: CreateUserDto): Promise<User> {
  const validatedData = createUserSchema.parse(userData);
  // ...
}
```

## 実装時のチェックリスト

実装前に、以下を確認してください：

- [ ] 該当するドキュメントを読んだか（CODING_RULES.md, ARCHITECTURE.md等）
- [ ] 入力検証を実装したか
- [ ] エラーハンドリングを実装したか
- [ ] ログ出力を実装したか（必要に応じて）
- [ ] セキュリティ対策を実装したか

## Context7の使用

最新のベストプラクティスを確認するため、必要に応じてContext7を使用してください。

例：
```
Context7でbcryptの最新の使い方を確認
Context7でZodのエラーハンドリング方法を確認
```

## 出力メッセージ

実装完了後、以下のメッセージを表示してください：

```
✅ 実装が完了しました！

📝 作成されたファイル:
- [ファイルパス1]
- [ファイルパス2]

🧪 テスト結果:
- 正常系: ✅ パス
- 異常系: ✅ パス
- 境界値: ✅ パス

合計: X件のテストがすべてパスしました

🚀 次のステップ:
1. コードレビューを実施してください（推奨）
   \`\`\`
   /code-review
   \`\`\`

2. 問題がなければコミットしてください
   \`\`\`
   /commit
   \`\`\`
```

## エラー時の対応

テストが失敗した場合：

1. **エラーメッセージを確認**
   - どのテストが失敗したか
   - 期待値と実際の値は何か

2. **原因を特定**
   - ロジックのミスか
   - バリデーションの問題か
   - データベースの問題か

3. **修正して再度テスト実行**

4. **それでも解決しない場合**
   - docs/ のドキュメントを再確認
   - Context7で最新の情報を確認
   - 開発者に質問

## 注意

- テストがパスすることが最優先です
- ただし、セキュリティ対策を省略してはいけません
- 不明な点がある場合は、必ずドキュメントを確認してください
