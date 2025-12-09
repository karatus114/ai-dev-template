# テスト方針（TDD）

このドキュメントでは、テスト駆動開発（TDD）のアプローチとテスト方針を定義します。

---

## TDD（テスト駆動開発）とは

### 基本方針

このプロジェクトでは、**テスト駆動開発（TDD）**を採用します。

**TDDの流れ**:

```
1. テストを書く（Red）
   ↓
2. テストを実行（失敗することを確認）
   ↓
3. 最小限の実装を書く（Green）
   ↓
4. テストを実行（成功することを確認）
   ↓
5. リファクタリング（Refactor）
   ↓
6. テストを実行（成功することを確認）
```

### TDDのメリット

- ✅ **バグの早期発見**
- ✅ **仕様の明確化**
- ✅ **リファクタリングの安全性**
- ✅ **ドキュメントとしての役割**

---

## TDDのワークフロー

### 1. テスト作成（`/create-test` コマンド）

**実装前にテストを作成します。**

```bash
/create-test
```

**テスト作成の流れ**:

1. **要件を確認する**
2. **テスト観点を洗い出す**
   - 正常系
   - 異常系
   - 境界値
3. **ユーザーに確認する**（テスト観点が正しいか）
4. **テストコードを作成する**

### 2. テストの確認

テストを実行して、**失敗することを確認**してください。

```bash
# テスト実行
npm test  # または pytest, go test等
```

### 3. テストのコミット

テストが作成できたら、**コミット**してください。

```bash
/commit
# 例: test: ユーザー登録のテストを追加
```

### 4. 実装（`/implement-for-test` コマンド）

テストがパスする最小限の実装を行います。

```bash
/implement-for-test
```

**実装のルール**:

- **テストを変更しない**
- **テストがすべてパスするまで修正を繰り返す**
- **モック実装やハードコードは禁止**

### 5. 実装のコミット

テストがパスしたら、**コミット**してください。

```bash
/commit
# 例: feat: ユーザー登録機能を実装
```

---

## テスト観点

### 必須のテスト観点

すべての機能で、以下の観点をテストしてください。

#### 1. 正常系

**期待通りに動作することを確認**

```typescript
test('should create a new user with valid data', async () => {
  const userData = {
    email: 'test@example.com',
    password: 'Password123',
  };

  const user = await userService.create(userData);

  expect(user.id).toBeDefined();
  expect(user.email).toBe('test@example.com');
});
```

#### 2. 異常系

**エラー時に適切に処理されることを確認**

```typescript
test('should throw ValidationError when email is invalid', async () => {
  const userData = {
    email: 'invalid-email',
    password: 'Password123',
  };

  await expect(userService.create(userData)).rejects.toThrow(ValidationError);
});

test('should throw ConflictError when email already exists', async () => {
  const userData = {
    email: 'existing@example.com',
    password: 'Password123',
  };

  await expect(userService.create(userData)).rejects.toThrow(ConflictError);
});
```

#### 3. 境界値

**境界値での動作を確認**

```typescript
test('should accept password with exactly 8 characters', async () => {
  const userData = {
    email: 'test@example.com',
    password: 'Pass123!', // 8文字
  };

  const user = await userService.create(userData);
  expect(user).toBeDefined();
});

test('should reject password with 7 characters', async () => {
  const userData = {
    email: 'test@example.com',
    password: 'Pass12!', // 7文字
  };

  await expect(userService.create(userData)).rejects.toThrow(ValidationError);
});
```

---

## 機能別のテスト観点

### 認証機能

- [ ] 正しいメールアドレス・パスワードでログインできる
- [ ] 誤ったパスワードでログインできない
- [ ] 存在しないメールアドレスでログインできない
- [ ] パスワードがハッシュ化されている
- [ ] JWTトークンが正しく生成される
- [ ] トークンの有効期限が設定されている

### データベース操作

- [ ] データが正しく作成される
- [ ] データが正しく取得される
- [ ] データが正しく更新される
- [ ] データが正しく削除される（論理削除）
- [ ] 存在しないIDで取得した場合、nullまたはエラー
- [ ] 外部キー制約が正しく機能する

### API

- [ ] 正しいリクエストで200/201が返る
- [ ] 不正なリクエストで400が返る
- [ ] 認証なしで401が返る
- [ ] 権限なしで403が返る
- [ ] 存在しないリソースで404が返る
- [ ] レスポンス形式が正しい
- [ ] エラーレスポンスにtrace_idが含まれる

### ファイルアップロード

- [ ] 許可されたファイル形式がアップロードできる
- [ ] 許可されていないファイル形式はエラー
- [ ] ファイルサイズ制限が機能する
- [ ] ファイル名がサニタイズされている

---

## テストファイルの命名規則

**[`/init-project` で技術スタックに応じたテストファイル命名規則が設定されます]**

### TypeScript / JavaScript

```
src/services/UserService.ts
src/services/UserService.test.ts
```

または

```
src/services/UserService.ts
src/services/__tests__/UserService.test.ts
```

### Python

```
app/services/user_service.py
tests/services/test_user_service.py
```

---

## テストの種類

### ユニットテスト

**単一の関数・メソッドをテストする**

```typescript
// ✅ 良い例：ユニットテスト
test('calculateTotal should return sum of prices', () => {
  const items = [
    { price: 100 },
    { price: 200 },
    { price: 300 },
  ];

  const total = calculateTotal(items);

  expect(total).toBe(600);
});
```

### 統合テスト

**複数のコンポーネントを組み合わせてテストする**

```typescript
// ✅ 良い例：統合テスト
test('should create user and send welcome email', async () => {
  const userData = {
    email: 'test@example.com',
    password: 'Password123',
  };

  const user = await userService.create(userData);

  // DBに保存されていることを確認
  const savedUser = await userRepository.findById(user.id);
  expect(savedUser).toBeDefined();

  // メールが送信されていることを確認
  expect(emailService.send).toHaveBeenCalledWith(
    'test@example.com',
    'Welcome'
  );
});
```

### E2Eテスト（End-to-End）

**実際のユーザー操作をシミュレートする**

```typescript
// ✅ 良い例：E2Eテスト
test('user can sign up and log in', async () => {
  await page.goto('http://localhost:3000/signup');

  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'Password123');
  await page.click('button[type="submit"]');

  await expect(page).toHaveURL('http://localhost:3000/dashboard');
});
```

---

## モック・スタブの使用

### モックとは

外部依存をシミュレートするための偽のオブジェクト。

### モックの使い方

```typescript
// メールサービスをモック化
const emailService = {
  send: jest.fn(),
};

test('should send welcome email after user creation', async () => {
  const userData = {
    email: 'test@example.com',
    password: 'Password123',
  };

  await userService.create(userData, emailService);

  expect(emailService.send).toHaveBeenCalledWith(
    'test@example.com',
    'Welcome'
  );
});
```

### モックを使うべき場所

- ✅ 外部API呼び出し
- ✅ メール送信
- ✅ ファイル操作
- ✅ 日時取得（`Date.now()`等）

### モックを使うべきでない場所

- ❌ ビジネスロジック
- ❌ データベース（統合テストでは実DBを使う）

---

## カバレッジ目標

### カバレッジ率

- **全体**: 80%以上
- **Service層**: 90%以上
- **Repository層**: 80%以上
- **Controller層**: 70%以上

### カバレッジの確認

```bash
# TypeScript / JavaScript
npm run test:coverage

# Python
pytest --cov=app tests/
```

### カバレッジレポート

カバレッジレポートは、以下の形式で確認してください。

```
File                  | % Stmts | % Branch | % Funcs | % Lines |
----------------------|---------|----------|---------|---------|
UserService.ts        |   95.00 |    90.00 |  100.00 |   95.00 |
UserRepository.ts     |   85.00 |    80.00 |   90.00 |   85.00 |
----------------------|---------|----------|---------|---------|
All files             |   90.00 |    85.00 |   95.00 |   90.00 |
```

---

## テストデータ

### テストデータの管理

- **ファクトリーパターンを使用する**
- **テストごとに独立したデータを用意する**
- **テスト後にデータをクリーンアップする**

### 例（TypeScript）

```typescript
// ファクトリー関数
function createUserData(overrides = {}) {
  return {
    email: 'test@example.com',
    password: 'Password123',
    name: 'Test User',
    ...overrides,
  };
}

// テストで使用
test('should create user', async () => {
  const userData = createUserData({ email: 'custom@example.com' });
  const user = await userService.create(userData);
  expect(user.email).toBe('custom@example.com');
});
```

---

## テスト実行

### ローカルでのテスト実行

```bash
# すべてのテストを実行
npm test  # または pytest

# 特定のファイルのみ実行
npm test UserService.test.ts

# ウォッチモード
npm test -- --watch
```

### CI/CDでのテスト実行

プルリクエスト作成時、自動的にテストが実行されるように設定してください。

---

## AIへの指示の仕方

### テスト作成の依頼

```
/create-test

「ユーザー登録機能のテストを作成してください」
```

AIが以下を自動で行います：

1. **要件を確認**
2. **テスト観点を洗い出し**（正常系、異常系、境界値）
3. **ユーザーに確認**
4. **テストコードを作成**

### 実装の依頼

```
/implement-for-test

「テストがパスする実装を作成してください」
```

AIが以下を自動で行います：

1. **テストを確認**
2. **最小限の実装を作成**
3. **テストを実行**
4. **すべてのテストがパスするまで修正**

---

## テストフレームワーク

**[`/init-project` で技術スタックに応じたテストフレームワークが設定されます]**

### TypeScript / JavaScript

推奨フレームワーク:
- **Jest**
- **Vitest**

### Python

推奨フレームワーク:
- **pytest**
- **unittest**

---

## 禁止事項

- ❌ **実装前にテストを書かない**
- ❌ **テストをスキップする**
- ❌ **テストが失敗している状態でコミット**
- ❌ **テストのための実装**（本来の仕様と異なる実装）
- ❌ **モック実装やハードコード**

---

## 参考資料

- [WORKFLOW.md](WORKFLOW.md) - 開発の進め方
- [ARCHITECTURE.md](ARCHITECTURE.md) - 設計方針
- [CODING_RULES.md](CODING_RULES.md) - コード規約

---

## 更新履歴

- **[日付]**: `/init-project` でプロジェクト初期化
