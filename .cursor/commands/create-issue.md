GitHub Issueを作成します。

## 手順

### 1. type を判断する

ユーザーの依頼内容から、適切な type を判断してください。

| type | 用途 | テンプレート |
|------|------|------------|
| `feat` | 新機能 | feature.md |
| `fix` | バグ修正 | bug.md |
| `docs` | ドキュメント | feature.md |
| `refactor` | リファクタリング | feature.md |
| `test` | テスト | feature.md |
| `chore` | その他 | feature.md |

### 2. テンプレートを適用する

type に応じて、適切なテンプレートを使用してください。

#### 機能追加（feature.md）

```markdown
## 概要

[簡潔な概要を記載]

## 背景・目的

[なぜこの機能が必要なのか]

## 実現したいこと

- [ ] [実現したいこと1]
- [ ] [実現したいこと2]
- [ ] [実現したいこと3]

## 受け入れ条件

- [ ] [受け入れ条件1]
- [ ] [受け入れ条件2]
- [ ] [受け入れ条件3]

## 備考

[追加の情報があれば記載]
```

#### バグ報告（bug.md）

```markdown
## 概要

[バグの簡潔な説明]

## 再現手順

1. [ステップ1]
2. [ステップ2]
3. [ステップ3]

## 期待する動作

[本来どうあるべきか]

## 実際の動作

[実際に何が起きているか]

## 環境

- OS: [例: Windows 11]
- ブラウザ: [例: Chrome 120]
- バージョン: [例: v1.2.3]

## 備考

[スクリーンショット、エラーログ等を添付]
```

### 3. ラベルを選択する

適切なラベルを選択してください。

| ラベル | 用途 |
|-------|------|
| `feat` | 新機能 |
| `fix` | バグ修正 |
| `docs` | ドキュメント |
| `refactor` | リファクタリング |
| `test` | テスト |
| `chore` | その他 |
| `priority: high` | 優先度: 高 |
| `priority: medium` | 優先度: 中 |
| `priority: low` | 優先度: 低 |

### 4. タイトルを生成する

以下の形式でタイトルを生成してください：

```
[type] 概要
```

**例**:
```
[feat] ユーザー検索機能の追加
[fix] ログイン時のバリデーションエラー
[docs] API仕様書の更新
```

### 5. ユーザーに確認する

生成したIssueの内容をユーザーに提示し、確認してください。

**例**:
```
以下の内容でIssueを作成します。よろしいですか？

タイトル: [feat] ユーザー検索機能の追加

本文:
## 概要

ユーザー検索機能を追加する

## 背景・目的

管理者がユーザーを検索できるようにしたい

## 実現したいこと

- [ ] 名前で検索
- [ ] メールアドレスで検索
- [ ] 登録日で絞り込み
- [ ] ページネーション

## 受け入れ条件

- [ ] 検索APIが動作する
- [ ] フロントエンドで検索フォームが表示される
- [ ] テストが書かれている
- [ ] ドキュメントが更新されている

## 備考

パフォーマンスに注意すること

ラベル: feat, priority: medium
```

### 6. Issue を作成する

GitHub CLI (`gh`) を使用してIssueを作成してください：

```bash
gh issue create \
  --title "[type] 概要" \
  --body "[本文]" \
  --label "feat,priority:medium"
```

#### コマンド例

```bash
gh issue create \
  --title "[feat] ユーザー検索機能の追加" \
  --label "feat,priority:medium" \
  --body "$(cat <<'EOF'
## 概要

ユーザー検索機能を追加する

## 背景・目的

管理者がユーザーを検索できるようにしたい

## 実現したいこと

- [ ] 名前で検索
- [ ] メールアドレスで検索
- [ ] 登録日で絞り込み
- [ ] ページネーション

## 受け入れ条件

- [ ] 検索APIが動作する
- [ ] フロントエンドで検索フォームが表示される
- [ ] テストが書かれている
- [ ] ドキュメントが更新されている

## 備考

パフォーマンスに注意すること
EOF
)"
```

### 7. Issue番号を返す

Issue作成が完了したら、Issue番号とURLを表示してください。

## 出力メッセージ

Issue作成完了後、以下のメッセージを表示してください：

```
✅ Issueが作成されました！

🔗 Issue URL:
https://github.com/[owner]/[repo]/issues/[number]

📋 Issue番号: #[number]

🏷️ ラベル:
- feat
- priority: medium

🚀 次のステップ:
1. Issueの内容を確認してください
2. ブランチを作成してください
   \`\`\`bash
   git checkout -b feat/[number]-user-search
   \`\`\`
3. 開発を開始してください
   - `/create-test` でテストを作成
   - `/implement-for-test` で実装
   - `/commit` でコミット
   - `/create-pr` でPR作成
```

## エラー時の対応

### GitHub CLI がインストールされていない場合

```
❌ エラー: GitHub CLI (gh) がインストールされていません

インストール方法:
- macOS: `brew install gh`
- Windows: `winget install GitHub.cli`
- Linux: https://github.com/cli/cli#installation

インストール後、以下のコマンドで認証してください:
`gh auth login`
```

### GitHub CLI が認証されていない場合

```
❌ エラー: GitHub CLI が認証されていません

以下のコマンドで認証してください:
`gh auth login`
```

## 注意

- タイトルは `[type] 概要` の形式を厳守してください
- 受け入れ条件を必ず記載してください
- 優先度ラベルを適切に設定してください
- 大きすぎるIssueは小さく分割してください

## 参考資料

- [docs/ISSUE_RULES.md](../docs/ISSUE_RULES.md) - Issue運用ルール
- [.github/ISSUE_TEMPLATE/feature.md](../.github/ISSUE_TEMPLATE/feature.md) - 機能追加テンプレート
- [.github/ISSUE_TEMPLATE/bug.md](../.github/ISSUE_TEMPLATE/bug.md) - バグ報告テンプレート
