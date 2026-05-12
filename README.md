# agent-default

Android 团队 AI Agent 基础规则体系，适配 Claude Code / Codex。

一行命令接入任意项目，让团队所有成员的 AI 输出对齐到架构师水平。

---

## 快速接入

在项目根目录执行：

```bash
curl -fsSL https://raw.githubusercontent.com/valiantyan/agent-default/main/install.sh | bash
```

执行后：
- `agent-default/` 目录创建在当前项目下
- `CLAUDE.md` 自动生成在项目根目录
- `agent-default/` 自动写入 `.gitignore`（本地私有，不提交）

---

## 安装后的结构

```
your-project/
├── CLAUDE.md                        ← Agent 入口，自动加载规则
└── agent-default/
    ├── identity.md                  ← Agent 角色定义
    ├── soul.md                      ← Agent 人格与风格
    ├── user.md                      ← 用户画像（需手动填写）
    ├── core-rules.md                ← 核心执行规则
    ├── regression.md                ← 错误记录与闭环
    └── memory/
        ├── MEMORY.md                ← 工作记忆（Agent 自动维护）
        └── sessions/
            ├── README.md            ← 归档说明
            └── YYYY-MM.md           ← 月度归档（使用中自动生成）
```

---

## 文件说明

### `CLAUDE.md`
Agent 入口文件，放在项目根目录，Claude Code 自动识别并加载。

定义三件事：
- **热层加载顺序**：每次会话启动时按顺序读取哪些文件
- **会话结束规则**：Agent 结束时静默更新 `MEMORY.md` 的哪些内容
- **错误记录规则**：什么情况下静默写入 `regression.md`

---

### `identity.md`
定义 Agent 的**角色边界**——它是谁、有哪四种执行模式、什么时候主动开口。

核心设计：Agent 根据任务性质自动判断用户当前角色，并切换对应执行模式：

| 用户角色 | Agent 默认模式 |
|---------|--------------|
| 功能开发 | 高效执行，直接动手 |
| 模块负责人 | 谨慎问询，影响他人时先说 |
| 架构把控 | 严格遵令，必须先列方案 |

---

### `soul.md`
定义 Agent 的**人格与风格**——怎么说话、怎么面对不确定、怎么面对分歧。

核心约束：
- 结论前置，不绕弯
- 一次说完，不留尾巴
- Bug 分析必须有根因 + 证据，不写没有证据的推测
- 不同水平的用户，解释深度不同，但方案质量不降级

---

### `user.md`
定义**当前团队的使用场景**——成员水平分布、角色构成、技术栈基准。

**安装后需要手动编辑这个文件**，填写团队实际情况。这是唯一需要人工维护的文件。

重新执行安装脚本不会覆盖此文件。

---

### `core-rules.md`
定义**所有场景通用的执行规则**，每次会话必读。

包含五块内容：
- **优先级**：正确性 > 可维护性 > 性能 > 简洁性 > 速度
- **执行阈值**：什么时候直接执行，什么时候暂停问用户
- **改动范围原则**：只动需要动的，不顺手优化周边
- **Kotlin/Android 架构硬约束**：UseCase 接口化、ViewModel 隔离、禁止 `!!` 等
- **Bug 分析格式**：根因 + 证据 + 修复 + 关联风险，四项缺一不可

---

### `regression.md`
**错误记录与闭环机制**。

工作流程：
```
Agent 犯错 → 用户纠正 → Agent 判断是否会复现
    → 会复现：静默写入 regression.md
    → 同类错误累计 2 次：提示更新 core-rules.md
    → core-rules.md 补充规则
```

这个文件让规则体系越用越精准，不依赖人的主动维护意识。

---

### `memory/MEMORY.md`
**跨会话工作记忆**，Agent 每次会话结束后自动更新，不需要人工干预。

采用双层结构：

```
## Summary for Agent（前 200 行，每次必读）
  - 当前项目阶段
  - 关键约定
  - 跨会话待跟进项
  - 最近会话摘要（保留 3 条）
  - 架构决策速查

## Details（200 行后，按需读取）
  - 架构决策完整记录
  - 历史会话归档入口
```

当 Summary 超过 150 行时，Agent 会提示将旧摘要归档到 `memory/sessions/YYYY-MM.md`。

重新执行安装脚本不会覆盖此文件。

---

### `memory/sessions/`
月度归档目录。当 `MEMORY.md` 的 Summary 区块过长时，通过以下方式触发归档：

```
告诉 Agent：帮我把旧的会话摘要归档到 memory/sessions/2026-05.md
```

Agent 会自动创建月度文件并移入旧记录，`MEMORY.md` 恢复精简状态。

---

## 更新规则文件

重新执行安装命令即可同步 GitHub 上的最新版本：

```bash
curl -fsSL https://raw.githubusercontent.com/valiantyan/agent-default/main/install.sh | bash
```

| 文件 | 更新行为 |
|------|---------|
| `identity.md` `soul.md` `core-rules.md` `regression.md` | 覆盖更新 |
| `user.md` | 跳过（保留团队自定义） |
| `memory/MEMORY.md` | 跳过（保留项目记忆） |
| `CLAUDE.md` | 询问是否覆盖 |

---

## Token 消耗

热层（每次会话必读）约 **1282 tokens**，占 Claude Code 200k 上下文的 0.6%。

| 文件 | tokens |
|------|--------|
| `identity.md` | ~241 |
| `soul.md` | ~238 |
| `user.md` | ~179 |
| `core-rules.md` | ~300 |
| `MEMORY.md` Summary | ~123 |
| `CLAUDE.md` | ~137 |
| **合计** | **~1218** |
