#!/usr/bin/env bash
# agent-default 安装脚本
# 用法：在项目根目录执行
# curl -fsSL https://raw.githubusercontent.com/valiantyan/agent-default/main/install.sh | bash

set -e

REPO="valiantyan/agent-default"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
AGENT_DIR="$(pwd)/agent-default"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}[agent-default]${NC} $1"; }
warn()  { echo -e "${YELLOW}[agent-default]${NC} $1"; }
error() { echo -e "${RED}[agent-default]${NC} $1"; exit 1; }

command -v curl >/dev/null 2>&1 || error "需要 curl，请先安装"

info "安装目录: ${AGENT_DIR}"

if [ -d "${AGENT_DIR}" ]; then
    warn "检测到已有安装，重新执行会更新基础文件（user.md 和 MEMORY.md 不覆盖）"
    read -r -p "  继续？[y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { info "已取消"; exit 0; }
fi

mkdir -p "${AGENT_DIR}/memory/sessions"

# 每次覆盖的基础文件（不含 README.md）
for file in identity.md soul.md core-rules.md regression.md memory/sessions/README.md; do
    curl -fsSL "${BASE_URL}/${file}" -o "${AGENT_DIR}/${file}"
    info "✓ agent-default/${file}"
done

# user.md：仅首次创建，不覆盖
if [ ! -f "${AGENT_DIR}/user.md" ]; then
    curl -fsSL "${BASE_URL}/user.md" -o "${AGENT_DIR}/user.md"
    info "✓ agent-default/user.md（首次创建）"
else
    warn "~ agent-default/user.md 已存在，跳过"
fi

# MEMORY.md：仅首次创建，不覆盖
if [ ! -f "${AGENT_DIR}/memory/MEMORY.md" ]; then
    curl -fsSL "${BASE_URL}/memory/MEMORY.md" -o "${AGENT_DIR}/memory/MEMORY.md"
    info "✓ agent-default/memory/MEMORY.md（首次创建）"
else
    warn "~ agent-default/memory/MEMORY.md 已存在，跳过"
fi

# ── CLAUDE.md 处理 ────────────────────────────────────
CLAUDE_FILE="$(pwd)/CLAUDE.md"
CLAUDE_CONTENT=$(curl -fsSL "${BASE_URL}/CLAUDE.md" \
    | sed 's|/Users/yanhao/yh-agent|agent-default|g')

if [ -f "${CLAUDE_FILE}" ]; then
    # 已有 CLAUDE.md：检查是否已包含 agent-default 内容，避免重复追加
    if grep -q "agent-default/identity.md" "${CLAUDE_FILE}"; then
        warn "~ CLAUDE.md 已包含 agent-default 规则，跳过"
    else
        echo "" >> "${CLAUDE_FILE}"
        echo "---" >> "${CLAUDE_FILE}"
        echo "" >> "${CLAUDE_FILE}"
        echo "${CLAUDE_CONTENT}" >> "${CLAUDE_FILE}"
        info "✓ CLAUDE.md 已追加 agent-default 规则"
    fi
else
    echo "${CLAUDE_CONTENT}" > "${CLAUDE_FILE}"
    info "✓ CLAUDE.md（首次创建）"
fi

# ── .gitignore 处理 ───────────────────────────────────
GITIGNORE_FILE="$(pwd)/.gitignore"
GITIGNORE_ENTRY="agent-default/"

add_to_gitignore() {
    echo "" >> "${GITIGNORE_FILE}"
    echo "# agent-default 规则目录（本地私有，不提交）" >> "${GITIGNORE_FILE}"
    echo "${GITIGNORE_ENTRY}" >> "${GITIGNORE_FILE}"
    info "✓ .gitignore 已添加 agent-default/"
}

if [ -f "${GITIGNORE_FILE}" ]; then
    if grep -qx "${GITIGNORE_ENTRY}" "${GITIGNORE_FILE}"; then
        warn "~ .gitignore 已包含 agent-default/，跳过"
    else
        add_to_gitignore
    fi
else
    warn "未检测到 .gitignore，请手动添加 agent-default/ 以避免提交到 git"
fi

echo ""
info "完成 🎉"
echo ""
echo "  规则目录: ${AGENT_DIR}"
echo "  项目入口: ${CLAUDE_FILE}"
echo ""
echo "  下一步："
echo "  1. 编辑 agent-default/user.md，填写团队信息"
echo "  2. 用 Claude Code 打开项目，规则自动加载"
echo ""
echo "  更新基础文件（保留 user.md 和记忆）："
echo "  curl -fsSL ${BASE_URL}/install.sh | bash"
