TDDアプローチでテストを作成します。

## 重要

**実装は書かずに、テストのみを作成してください。**

## 手順

### 1. 要件を確認する

ユーザーから、以下の情報を確認してください：

- 何をテストするのか（機能、API、関数等）
- 入力は何か
- 期待される出力は何か
- エラーケースは何か

### 2. テスト観点を洗い出す

docs/TESTING.md に従って、以下の観点を洗い出してください：

#### 必須観点

- **正常系**: 期待通りに動作することを確認
- **異常系**: エラー時に適切に処理されることを確認
- **境界値**: 境界値での動作を確認

#### 機能別の追加観点

**認証機能の場合**:
- [ ] 正しいメールアドレス・パスワードでログインできる
- [ ] 誤ったパスワードでログインできない
- [ ] 存在しないメールアドレスでログインできない
- [ ] パスワードがハッシュ化されている
- [ ] JWTトークンが正しく生成される

**データベース操作の場合**:
- [ ] データが正しく作成される
- [ ] データが正しく取得される
- [ ] データが正しく更新される
- [ ] データが正しく削除される（論理削除）
- [ ] 存在しないIDで取得した場合、nullまたはエラー

**APIの場合**:
- [ ] 正しいリクエストで200/201が返る
- [ ] 不正なリクエストで400が返る
- [ ] 認証なしで401が返る
- [ ] 権限なしで403が返る
- [ ] 存在しないリソースで404が返る
- [ ] レスポンス形式が正しい

**ファイルアップロードの場合**:
- [ ] 許可されたファイル形式がアップロードできる
- [ ] 許可されていないファイル形式はエラー
- [ ] ファイルサイズ制限が機能する

### 3. ユーザーに確認する

洗い出したテスト観点をユーザーに提示し、確認してください。

**例**:
```
以下のテスト観点でテストを作成します。よろしいですか？

【正常系】
- 有効なメールアドレスとパスワードでユーザーが作成される
- 作成されたユーザーのパスワードがハッシュ化されている

【異常系】
- 無効なメールアドレスでValidationErrorがスローされる
- 既に存在するメールアドレスでConflictErrorがスローされる
- パスワードが8文字未満でValidationErrorがスローされる

【境界値】
- パスワードが正確に8文字の場合、ユーザーが作成される
- パスワードが7文字の場合、ValidationErrorがスローされる
```

### 4. テストコードを作成する

AGENTS.md から技術スタックを確認し、適切なテストフレームワークを使用してください。

#### TypeScript / JavaScript（Jest / Vitest）

```typescript
import { describe, it, expect, beforeEach } from '@jest/globals';
import { UserService } from '@/services/UserService';
import { ValidationError, ConflictError } from '@/errors';

describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    userService = new UserService();
  });

  describe('create', () => {
    describe('正常系', () => {
      it('有効なメールアドレスとパスワードでユーザーが作成される', async () => {
        const userData = {
          email: 'test@example.com',
          password: 'Password123',
        };

        const user = await userService.create(userData);

        expect(user.id).toBeDefined();
        expect(user.email).toBe('test@example.com');
        expect(user.password).not.toBe('Password123'); // パスワードはハッシュ化される
      });

      it('パスワードがハッシュ化される', async () => {
        const userData = {
          email: 'test@example.com',
          password: 'Password123',
        };

        const user = await userService.create(userData);

        expect(user.password).not.toBe('Password123');
        expect(user.password.length).toBeGreaterThan(20); // bcryptハッシュは60文字
      });
    });

    describe('異常系', () => {
      it('無効なメールアドレスでValidationErrorがスローされる', async () => {
        const userData = {
          email: 'invalid-email',
          password: 'Password123',
        };

        await expect(userService.create(userData)).rejects.toThrow(ValidationError);
      });

      it('既に存在するメールアドレスでConflictErrorがスローされる', async () => {
        const userData = {
          email: 'existing@example.com',
          password: 'Password123',
        };

        // 事前にユーザーを作成
        await userService.create(userData);

        // 同じメールアドレスで再度作成
        await expect(userService.create(userData)).rejects.toThrow(ConflictError);
      });

      it('パスワードが8文字未満でValidationErrorがスローされる', async () => {
        const userData = {
          email: 'test@example.com',
          password: 'Pass12', // 6文字
        };

        await expect(userService.create(userData)).rejects.toThrow(ValidationError);
      });
    });

    describe('境界値', () => {
      it('パスワードが正確に8文字の場合、ユーザーが作成される', async () => {
        const userData = {
          email: 'test@example.com',
          password: 'Pass123!', // 8文字
        };

        const user = await userService.create(userData);

        expect(user).toBeDefined();
      });

      it('パスワードが7文字の場合、ValidationErrorがスローされる', async () => {
        const userData = {
          email: 'test@example.com',
          password: 'Pass12!', // 7文字
        };

        await expect(userService.create(userData)).rejects.toThrow(ValidationError);
      });
    });
  });
});
```

#### Python（pytest）

```python
import pytest
from app.services.user_service import UserService
from app.errors import ValidationError, ConflictError

class TestUserService:
    @pytest.fixture
    def user_service(self):
        return UserService()

    class TestCreate:
        class TestNormalCase:
            def test_create_user_with_valid_data(self, user_service):
                """有効なメールアドレスとパスワードでユーザーが作成される"""
                user_data = {
                    'email': 'test@example.com',
                    'password': 'Password123',
                }

                user = user_service.create(user_data)

                assert user.id is not None
                assert user.email == 'test@example.com'
                assert user.password != 'Password123'  # パスワードはハッシュ化される

            def test_password_is_hashed(self, user_service):
                """パスワードがハッシュ化される"""
                user_data = {
                    'email': 'test@example.com',
                    'password': 'Password123',
                }

                user = user_service.create(user_data)

                assert user.password != 'Password123'
                assert len(user.password) > 20  # bcryptハッシュは60文字

        class TestAbnormalCase:
            def test_invalid_email_raises_validation_error(self, user_service):
                """無効なメールアドレスでValidationErrorがスローされる"""
                user_data = {
                    'email': 'invalid-email',
                    'password': 'Password123',
                }

                with pytest.raises(ValidationError):
                    user_service.create(user_data)

            def test_existing_email_raises_conflict_error(self, user_service):
                """既に存在するメールアドレスでConflictErrorがスローされる"""
                user_data = {
                    'email': 'existing@example.com',
                    'password': 'Password123',
                }

                # 事前にユーザーを作成
                user_service.create(user_data)

                # 同じメールアドレスで再度作成
                with pytest.raises(ConflictError):
                    user_service.create(user_data)

        class TestBoundaryValue:
            def test_password_with_exactly_8_characters(self, user_service):
                """パスワードが正確に8文字の場合、ユーザーが作成される"""
                user_data = {
                    'email': 'test@example.com',
                    'password': 'Pass123!',  # 8文字
                }

                user = user_service.create(user_data)

                assert user is not None

            def test_password_with_7_characters_raises_error(self, user_service):
                """パスワードが7文字の場合、ValidationErrorがスローされる"""
                user_data = {
                    'email': 'test@example.com',
                    'password': 'Pass12!',  # 7文字
                }

                with pytest.raises(ValidationError):
                    user_service.create(user_data)
```

## 出力メッセージ

テスト作成完了後、以下のメッセージを表示してください：

```
✅ テストの作成が完了しました！

📝 作成されたテスト:
- [ファイルパス]

🧪 テスト観点:
- 正常系: X件
- 異常系: Y件
- 境界値: Z件

🚀 次のステップ:
1. テストを実行して、失敗することを確認してください
   \`\`\`bash
   npm test  # または pytest
   \`\`\`

2. テストをコミットしてください
   \`\`\`
   /commit
   \`\`\`

3. 実装を作成してください
   \`\`\`
   /implement-for-test
   \`\`\`
```

## 注意

- **実装コードは一切書かないでください**
- テストのみを作成してください
- テスト実行後、失敗することを確認してください（Red）
- docs/TESTING.md を参照して、適切なテストを作成してください
