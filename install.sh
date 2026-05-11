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

# 每次覆盖的基础文件
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

# CLAUDE.md 写入项目根目录，使用相对路径
CLAUDE_FILE="$(pwd)/CLAUDE.md"

generate_claude() {
    curl -fsSL "${BASE_URL}/CLAUDE.md" \
        | sed 's|/Users/yanhao/yh-agent|agent-default|g' \
        > "${CLAUDE_FILE}"
    info "✓ CLAUDE.md（路径已设为相对路径 agent-default/）"
}

if [ -f "${CLAUDE_FILE}" ]; then
    warn "检测到已有 CLAUDE.md"
    read -r -p "  覆盖？[y/N] " confirm_claude
    [[ "$confirm_claude" =~ ^[Yy]$ ]] && generate_claude || warn "~ CLAUDE.md 保留原有内容"
else
    generate_claude
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
