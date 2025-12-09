#!/bin/bash

# AI駆動開発テンプレート - 初期セットアップスクリプト

set -e

echo "========================================="
echo "  AI駆動開発テンプレート - セットアップ"
echo "========================================="
echo ""

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 成功メッセージ
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# 警告メッセージ
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# エラーメッセージ
error() {
    echo -e "${RED}✗${NC} $1"
}

# 情報メッセージ
info() {
    echo -e "ℹ $1"
}

# 1. .env ファイルの作成
echo "1. .env ファイルの作成"
if [ -f ".env" ]; then
    warning ".env ファイルは既に存在します。スキップします。"
else
    if [ -f ".env.example" ]; then
        cp .env.example .env
        success ".env ファイルを作成しました"
        info "   次のステップで .env ファイルを編集してください"
    else
        error ".env.example ファイルが見つかりません"
        exit 1
    fi
fi
echo ""

# 2. Cursor用シンボリックリンクの作成（Unix系のみ）
echo "2. Cursor用シンボリックリンクの作成"
if [ ! -d ".cursor/commands" ]; then
    if [ -d ".claude/commands" ]; then
        # Windowsの場合はシンボリックリンクではなくディレクトリをコピー
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
            warning "Windowsではシンボリックリンクの代わりにディレクトリをコピーします"
            mkdir -p .cursor
            cp -r .claude/commands .cursor/commands
            success ".cursor/commands ディレクトリを作成しました（コピー）"
        else
            mkdir -p .cursor
            ln -s ../.claude/commands .cursor/commands
            success ".cursor/commands シンボリックリンクを作成しました"
        fi
    else
        error ".claude/commands ディレクトリが見つかりません"
        exit 1
    fi
else
    warning ".cursor/commands は既に存在します。スキップします。"
fi
echo ""

# 3. 必要なツールの確認
echo "3. 必要なツールの確認"

# Git確認
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    success "Git: $GIT_VERSION"
else
    error "Git がインストールされていません"
    info "   インストール方法: https://git-scm.com/"
fi

# GitHub CLI確認
if command -v gh &> /dev/null; then
    GH_VERSION=$(gh --version | head -n 1)
    success "GitHub CLI: $GH_VERSION"

    # GitHub CLI 認証確認
    if gh auth status &> /dev/null; then
        success "GitHub CLI: 認証済み"
    else
        warning "GitHub CLI: 未認証"
        info "   以下のコマンドで認証してください: gh auth login"
    fi
else
    warning "GitHub CLI がインストールされていません"
    info "   インストール方法:"
    info "   - macOS: brew install gh"
    info "   - Windows: winget install GitHub.cli"
    info "   - Linux: https://github.com/cli/cli#installation"
fi

# Node.js確認（存在する場合のみ）
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    success "Node.js: $NODE_VERSION"
fi

# npm確認（存在する場合のみ）
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    success "npm: $NPM_VERSION"
fi

# Python確認（存在する場合のみ）
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    success "Python: $PYTHON_VERSION"
elif command -v python &> /dev/null; then
    PYTHON_VERSION=$(python --version)
    success "Python: $PYTHON_VERSION"
fi

# pip確認（存在する場合のみ）
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version | awk '{print $2}')
    success "pip: $PIP_VERSION"
elif command -v pip &> /dev/null; then
    PIP_VERSION=$(pip --version | awk '{print $2}')
    success "pip: $PIP_VERSION"
fi

echo ""

# 4. 次のステップの案内
echo "========================================="
echo "  セットアップが完了しました！"
echo "========================================="
echo ""

echo "📋 次のステップ:"
echo ""

echo "1. プロジェクトの初期設定"
echo "   Claude Code または Cursor で以下のコマンドを実行してください："
echo "   ${GREEN}/init-project${NC}"
echo ""

echo "2. .env ファイルの編集"
echo "   .env ファイルを開いて、必要な環境変数を設定してください："
echo "   ${YELLOW}   - DATABASE_URL${NC}: データベース接続URL"
echo "   ${YELLOW}   - JWT_SECRET${NC}: JWT署名用のシークレットキー（ランダムな32文字以上）"
echo "   ${YELLOW}   - その他の環境変数${NC}: プロジェクトに応じて設定"
echo ""
echo "   JWT_SECRETの生成方法:"
echo "   ${GREEN}   openssl rand -base64 32${NC}"
echo ""

echo "3. 依存関係のインストール"
echo "   ${GREEN}/init-project${NC} コマンド実行後、表示される指示に従ってください"
echo ""

echo "4. 開発の開始"
echo "   以下のドキュメントを確認してください："
echo "   - ${GREEN}AGENTS.md${NC}: AI向けの基本指示"
echo "   - ${GREEN}docs/WORKFLOW.md${NC}: 開発の進め方"
echo "   - ${GREEN}docs/TESTING.md${NC}: TDDのアプローチ"
echo ""

echo "💡 利用可能なスラッシュコマンド:"
echo "   ${GREEN}/init-project${NC}      - プロジェクト初期設定"
echo "   ${GREEN}/setup${NC}             - 新規参画者セットアップ"
echo "   ${GREEN}/create-test${NC}       - テスト作成"
echo "   ${GREEN}/implement-for-test${NC} - 実装"
echo "   ${GREEN}/code-review${NC}       - コードレビュー"
echo "   ${GREEN}/commit${NC}            - コミット"
echo "   ${GREEN}/create-pr${NC}         - PR作成"
echo "   ${GREEN}/create-issue${NC}      - Issue作成"
echo ""

echo "🎉 開発を楽しんでください！"
echo ""
