コードレビューを実施します。

## レビュー観点

以下の観点でコードをレビューしてください：

### 1. 命名規則（docs/CODING_RULES.md 準拠）

- [ ] 変数名・関数名が適切か
- [ ] 命名規則に従っているか（キャメルケース、スネークケース等）
- [ ] 意味不明な略語がないか
- [ ] 誤解を招く名前がないか

### 2. レイヤー構成（docs/ARCHITECTURE.md 準拠）

- [ ] Controller → Service → Repository のレイヤー分離ができているか
- [ ] 各レイヤーの責務が適切か
- [ ] レイヤーをスキップしていないか
- [ ] 循環依存がないか

### 3. エラーハンドリング（docs/LOGGING.md 準拠）

- [ ] try-catch が適切に実装されているか
- [ ] エラーログが出力されているか
- [ ] エラーメッセージが適切か（機密情報が含まれていないか）
- [ ] エラー時に適切な HTTPステータスコードが返されるか

### 4. セキュリティ（docs/SECURITY.md 準拠）

- [ ] 入力検証が実装されているか
- [ ] SQLインジェクション対策がされているか（ORM使用、パラメータバインディング）
- [ ] XSS対策がされているか（ユーザー入力のエスケープ）
- [ ] 機密情報がハードコードされていないか
- [ ] 認証・認可が適切に実装されているか
- [ ] パスワードがハッシュ化されているか

### 5. パフォーマンス

- [ ] N+1問題が発生していないか
- [ ] 不要なループがないか
- [ ] 適切なインデックスが設定されているか
- [ ] キャッシュが活用されているか（必要に応じて）

### 6. テスト

- [ ] テストが書かれているか
- [ ] テストが正常系・異常系・境界値をカバーしているか
- [ ] テストがパスしているか

### 7. コード品質

- [ ] コメントが適切か（なぜそうするのかが書かれているか）
- [ ] 関数が単一責任か
- [ ] コードの重複がないか
- [ ] 不要なコメントやconsole.log()がないか

## Context7の使用

最新のベストプラクティスを確認するため、必要に応じてContext7を使用してください。

例：
```
Context7で[技術名]のベストプラクティスを確認
```

## 出力形式

レビュー結果を以下の形式で出力してください：

### 出力例

```markdown
# コードレビュー結果

## ✅ 良い点

- レイヤー分離が適切に実装されている
- エラーハンドリングが適切に行われている
- テストがしっかり書かれている

## ⚠️ 改善が必要な点

### 1. [高] セキュリティ: 入力検証が不足

**該当箇所**: `src/services/UserService.ts:45`

**問題**:
ユーザー入力がバリデーションなしで使用されています。

\`\`\`typescript
// ❌ 現在のコード
async createUser(userData: any) {
  return await this.userRepository.create(userData);
}
\`\`\`

**修正案**:
Zodなどのバリデーションライブラリを使用してください。

\`\`\`typescript
// ✅ 修正後
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

async createUser(userData: unknown) {
  const validatedData = userSchema.parse(userData);
  return await this.userRepository.create(validatedData);
}
\`\`\`

**参考**: `docs/SECURITY.md` - 入力検証

---

### 2. [中] パフォーマンス: N+1問題

**該当箇所**: `src/services/PostService.ts:67`

**問題**:
ループ内でデータベースクエリが実行されています（N+1問題）。

\`\`\`typescript
// ❌ 現在のコード
for (const post of posts) {
  post.author = await this.userRepository.findById(post.userId);
}
\`\`\`

**修正案**:
Eager Loadingを使用してください。

\`\`\`typescript
// ✅ 修正後
const posts = await this.postRepository.find({
  relations: ['author'],
});
\`\`\`

**参考**: `docs/ARCHITECTURE.md` - パフォーマンス最適化

---

### 3. [低] コード品質: 関数が長すぎる

**該当箇所**: `src/controllers/UserController.ts:23`

**問題**:
1つの関数が100行を超えており、複数の責務を持っています。

**修正案**:
関数を分割してください。

\`\`\`typescript
// ✅ 修正例
async createUser(req, res) {
  const validatedData = this.validateUserData(req.body);
  const user = await this.userService.create(validatedData);
  await this.sendWelcomeEmail(user);
  res.json({ user });
}
\`\`\`

**参考**: `docs/CODING_RULES.md` - ベストプラクティス

## 📊 総評

全体的にコードの品質は高いですが、セキュリティとパフォーマンスの面で改善の余地があります。
特に入力検証は必須ですので、必ず実装してください。

## 🎯 次のステップ

1. 高優先度の問題を修正
2. テストを追加（必要に応じて）
3. 再度 `/code-review` を実行
```

## 重要度の定義

- **[高]**: セキュリティ、バグ、データ損失のリスクがある
- **[中]**: パフォーマンス、保守性に影響がある
- **[低]**: コードの読みやすさ、一貫性に影響がある

## 注意

- 建設的なフィードバックを心がけてください
- 具体的な修正案を提示してください
- 該当するドキュメントへのリンクを含めてください
- Context7で最新のベストプラクティスを確認してください
