# CLAUDE.md

## 热层（每次必读，按顺序）

1. `agent-default/identity.md`
2. `agent-default/soul.md`
3. `agent-default/user.md`
4. `agent-default/core-rules.md`
5. `agent-default/memory/MEMORY.md`（只读 Summary for Agent 区块）

读完直接等待指令，不做汇报。

---

## 会话结束

静默更新 `agent-default/memory/MEMORY.md`：

**更新 Summary for Agent（必须保持在前 200 行内）**：
- 当前项目阶段（一句话更新）
- 关键约定（新增条目追加）
- 跨会话待跟进项（完成的打勾，新增的追加）
- 最近会话摘要（追加本次，超过 3 条删最旧的）
- 架构决策速查（新增结论行）

**更新 Details（完整记录，不限长度）**：
- 架构决策完整记录（新增完整行）

**触发归档条件**（满足时主动提示用户）：
- Summary for Agent 区块超过 150 行 → 提示将旧摘要移入 `memory/sessions/YYYY-MM.md`

---

## 错误记录

以下情况判断是否静默写入 `agent-default/regression.md`：
1. 用户明确否定纠正（"不对"、"你搞错了"等）
2. 用户推翻刚输出的方案
3. 用户说"换个方向"、"重新来"
4. 同一类问题本会话出现第二次

判断标准：这类情况以后还会出现吗？是 → 静默写入；否 → 跳过。
同类错误累计 2 次以上，主动提示用户补规则。
