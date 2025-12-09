docs/ 配下のルールと現在のコードを比較し、ルール違反を報告します。

## チェック観点

以下のドキュメントのルールに従っているか確認してください：

### 1. コード規約（docs/CODING_RULES.md）

- [ ] 命名規則に従っているか（キャメルケース、スネークケース等）
- [ ] ファイル命名規則に従っているか
- [ ] インポート順序が正しいか
- [ ] コメントが適切か（なぜそうするのかが書かれているか）
- [ ] 禁止事項に違反していないか

### 2. 設計方針（docs/ARCHITECTURE.md）

- [ ] レイヤー構成に従っているか（Controller → Service → Repository）
- [ ] 各レイヤーの責務が適切か
- [ ] エラーハンドリングが適切か
- [ ] レイヤーをスキップしていないか
- [ ] 循環依存がないか

### 3. データベース設計（docs/DATABASE.md）

- [ ] テーブル命名規則に従っているか（複数形、snake_case）
- [ ] カラム命名規則に従っているか（snake_case）
- [ ] 必須カラム（id, created_at, updated_at）が含まれているか
- [ ] インデックスが適切に設定されているか
- [ ] 外部キー制約が設定されているか

### 4. ログ出力（docs/LOGGING.md）

- [ ] JSON形式（構造化ログ）で出力されているか
- [ ] 必須フィールド（timestamp, level, event, trace_id）が含まれているか
- [ ] イベント命名規則に従っているか（動詞_名詞形式）
- [ ] エラーログに必要なフィールドが含まれているか
- [ ] 機密情報がログに出力されていないか

### 5. Git運用（docs/GIT_RULES.md）

- [ ] コミットメッセージが Conventional Commits形式に従っているか
- [ ] ブランチ命名規則に従っているか
- [ ] 複数の変更が1つのコミットにまとまっていないか

### 6. セキュリティ（docs/SECURITY.md）

- [ ] 入力検証が実装されているか
- [ ] SQLインジェクション対策がされているか
- [ ] XSS対策がされているか
- [ ] 機密情報がハードコードされていないか
- [ ] パスワードがハッシュ化されているか
- [ ] 認証・認可が適切に実装されているか

### 7. テスト（docs/TESTING.md）

- [ ] TDDアプローチに従っているか
- [ ] テストが正常系・異常系・境界値をカバーしているか
- [ ] テストファイル命名規則に従っているか
- [ ] カバレッジ目標を達成しているか

## 手順

### 1. コードを確認する

以下を確認してください：

- ソースコードファイル
- テストファイル
- マイグレーションファイル
- 設定ファイル
- コミット履歴

### 2. ルール違反を検出する

各ドキュメントのルールと照らし合わせて、違反を検出してください。

### 3. 違反を一覧で報告する

検出した違反を以下の形式で報告してください：

## 出力形式

```markdown
# ルール違反チェック結果

## ✅ 問題なし

以下のルールには違反していません：
- テスト方針（docs/TESTING.md）
- Git運用（docs/GIT_RULES.md）

## ⚠️ 違反が見つかりました

### 1. [高] セキュリティ: 入力検証なし

**該当箇所**: `src/services/UserService.ts:23`

**ルール**: docs/SECURITY.md - 入力検証

**違反内容**:
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

---

### 2. [中] コード規約: 命名規則違反

**該当箇所**: `src/utils/helpers.ts:12`

**ルール**: docs/CODING_RULES.md - 命名規則

**違反内容**:
関数名がキャメルケースではなくスネークケースになっています。

\`\`\`typescript
// ❌ 現在のコード
function get_user_name(user) {
  return user.name;
}
\`\`\`

**修正案**:

\`\`\`typescript
// ✅ 修正後
function getUserName(user: User): string {
  return user.name;
}
\`\`\`

---

### 3. [中] データベース設計: 必須カラムなし

**該当箇所**: `migrations/20240101_create_posts.sql`

**ルール**: docs/DATABASE.md - 必須カラム

**違反内容**:
`created_at`, `updated_at` カラムが含まれていません。

**修正案**:
以下のカラムを追加してください：

\`\`\`sql
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
deleted_at TIMESTAMP NULL DEFAULT NULL
\`\`\`

---

### 4. [低] ログ出力: イベント名が不適切

**該当箇所**: `src/services/AuthService.ts:45`

**ルール**: docs/LOGGING.md - イベント命名規則

**違反内容**:
イベント名が動詞_名詞形式になっていません。

\`\`\`typescript
// ❌ 現在のコード
logger.info('Login', { event: 'login' });
\`\`\`

**修正案**:

\`\`\`typescript
// ✅ 修正後
logger.info('User logged in', { event: 'user_login_success' });
\`\`\`

## 📊 違反サマリー

- 高: 1件（セキュリティ）
- 中: 2件（コード規約、データベース設計）
- 低: 1件（ログ出力）

合計: 4件の違反が見つかりました

## 🎯 優先的に修正すべき項目

1. **[高] セキュリティ: 入力検証なし** - すぐに修正してください
2. **[中] データベース設計: 必須カラムなし** - マイグレーションを作成してください
3. **[中] コード規約: 命名規則違反** - リファクタリングしてください

## 🚀 次のステップ

1. 高優先度の違反を修正してください
2. 修正後、再度 `/check-rules` を実行して確認してください
3. すべての違反が解消されたら、`/commit` でコミットしてください
```

## 重要度の定義

- **[高]**: セキュリティ、データ損失のリスクがある
- **[中]**: 保守性、パフォーマンスに影響がある
- **[低]**: コードの読みやすさ、一貫性に影響がある

## 注意

- 建設的なフィードバックを心がけてください
- 具体的な修正案を提示してください
- 該当するドキュメントへのリンクを含めてください
- 違反がない場合も、その旨を報告してください

## 参考資料

- [docs/CODING_RULES.md](../docs/CODING_RULES.md) - コード規約
- [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) - 設計方針
- [docs/DATABASE.md](../docs/DATABASE.md) - DB設計ルール
- [docs/LOGGING.md](../docs/LOGGING.md) - ログ規約
- [docs/GIT_RULES.md](../docs/GIT_RULES.md) - Git運用ルール
- [docs/SECURITY.md](../docs/SECURITY.md) - セキュリティ設計
- [docs/TESTING.md](../docs/TESTING.md) - テスト方針
