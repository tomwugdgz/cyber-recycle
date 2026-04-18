# 🔄 赛博回收 CyberRecycle - A2A Web4 企业数字遗产平台

> **项目位置**: `C:\Users\wolf2\WorkBuddy\Claw\cyber-recycle\`  
> **版本**: v1.0  
> **创建时间**: 2026-04-18  
> **技术栈**: WebMCP + Web4.0 + A2A 支付 + 智能合约

---

## 📍 项目位置

```
C:\Users\wolf2\WorkBuddy\Claw\cyber-recycle\
├── website/                    # 独立站（Next.js + 业务展示页）
├── mcp-server/                 # MCP 服务器（8 个核心工具）
├── contracts/                  # 智能合约（DataNFT + A2APayment）
├── mcp-integration/            # MCP 集成文档
├── skill-integration/          # Skill 集成文档
├── docs/                       # 项目文档（商业计划书/技术架构/路线图）
├── DEPLOYMENT.md              # 部署指南
└── README.md                  # 本文件
```

---

## 🎯 项目用途

### 什么是赛博回收？

**赛博回收**是一个基于 **WebMCP + Web4.0** 的企业数字遗产回收与蒸馏平台，专注于与倒闭公司合作，回收他们的工作流和公司数据，通过 AI 蒸馏为 AI 公司提供高质量训练数据和 RL（强化学习）环境。

### 核心业务

| 业务 | 描述 | 价格范围 |
|------|------|----------|
| **数据回收** | 从倒闭公司回收 Slack/Jira/GitHub/Confluence 等完整数据资产 | 1-10 万 USDC |
| **工作流回收** | 复刻真实办公流程，生成 RL 环境供 AI Agent 训练 | 5-50 万 USDC |
| **数据蒸馏** | AI 自动蒸馏成 L1-L5 质量等级的高质量训练集 | 0.1-10 万 USDC |

### 目标用户

1. **倒闭公司** - 寻求数据变现，将数字遗产转化为收入
2. **AI 公司** - 需要高质量训练数据和 RL 环境（如 Anthropic/OpenAI）
3. **数据经销商** - 批量采购→蒸馏→分级出售
4. **Agent 开发者** - 需要 RL 环境训练 AI Agent

---

## 🔗 A2A Web4 架构

### 什么是 A2A？

**A2A (Agent-to-Agent)** 是一种智能合约自动结算的支付系统，允许 AI Agent 之间直接进行交易，无需人工干预。

### 什么是 Web4.0？

**Web4.0** 是下一代互联网架构，核心特性包括：
- **数据主权** - 用户拥有数据所有权（通过 NFT 代表）
- **去中心化** - 无需中心化平台
- **智能合约** - 自动执行交易和规则
- **隐私保护** - ZK 零知识证明

### 赛博回收的 Web4.0 实现

| 特性 | 实现方式 | 用户价值 |
|------|----------|----------|
| **数据主权** | DataNFT 合约铸造数据 NFT | 原主人持续拥有数据所有权 |
| **版税机制** | 每次转售自动分配 20% 给原主人 | 持续被动收入 |
| **A2A 支付** | A2APayment 合约自动结算 | Agent 间无需人工干预 |
| **隐私保护** | ZK 证明验证数据脱敏 | 确保数据合规 |
| **去中心化存储** | IPFS 存储数据 | 数据永久保存 |

---

## 🏗️ 技术架构

### 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                     应用层 (Application Layer)                │
├─────────────────────────────────────────────────────────────┤
│  Next.js 网站  │  业务展示页  │  MCP 服务器  │  Skill 集成   │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                   协议层 (Protocol Layer)                     │
├─────────────────────────────────────────────────────────────┤
│     WebMCP 协议  │  A2A 智能合约  │  IPFS  │  ZK 证明        │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                   区块链层 (Blockchain Layer)                 │
├─────────────────────────────────────────────────────────────┤
│     Polygon/Arbitrum  │  DataNFT 合约  │  A2APayment 合约   │
└─────────────────────────────────────────────────────────────┘
```

### 核心组件

#### 1. DataNFT 合约
- **功能**: 铸造数据 NFT，代表数据所有权
- **版税**: 每次转售自动分配 20% 给原主人
- **ZK 证明**: 验证数据已脱敏
- **文件**: `contracts/DataNFT.sol`

#### 2. A2APayment 合约
- **功能**: Agent-to-Agent 支付系统
- **订阅模式**: 按调用次数计费，自动扣款
- **RL 环境**: 创建和管理 RL 训练环境
- **文件**: `contracts/A2APayment.sol`

#### 3. MCP 服务器
- **功能**: 提供 8 个核心工具
- **协议**: WebMCP 标准
- **端点**: `/health`, `/mcp/tools`, `/mcp/call`, `/mcp/docs`
- **文件**: `mcp-server/server.js`

#### 4. Next.js 网站
- **功能**: 用户界面和业务展示
- **页面**: 落地页 + 业务展示页
- **文件**: `website/src/app/`, `website/public/business.html`

---

## 🚀 如何启动

### 1. 启动 Next.js 网站

```bash
cd C:\Users\wolf2\WorkBuddy\Claw\cyber-recycle\website
npm install
npm run dev
# 访问: http://localhost:3000
# 业务展示页: http://localhost:3000/business.html
```

### 2. 启动 MCP 服务器

```bash
cd C:\Users\wolf2\WorkBuddy\Claw\cyber-recycle\mcp-server
npm install
npm start
# 访问: http://localhost:8080
# API 文档: http://localhost:8080/mcp/docs
# 工具列表: http://localhost:8080/mcp/tools
```

### 3. 编译智能合约

```bash
cd C:\Users\wolf2\WorkBuddy\Claw\cyber-recycle\contracts
npm install
npx hardhat compile
# 部署到测试网
npx hardhat run scripts/deploy.js --network mumbai
```

---

## 📊 MCP 工具列表

| 工具 | 功能 | 端点 |
|------|------|------|
| `collect_data` | 数据采集（Slack/Jira/GitHub/Confluence） | `POST /mcp/call` |
| `mint_data_nft` | 铸造数据 NFT | `POST /mcp/call` |
| `distill_dataset` | 数据蒸馏（L1-L5） | `POST /mcp/call` |
| `create_rl_environment` | 创建 RL 环境 | `POST /mcp/call` |
| `purchase_data` | 购买数据 | `POST /mcp/call` |
| `subscribe_rl_environment` | 订阅 RL 环境 | `POST /mcp/call` |
| `execute_rl_call` | 执行 RL 调用 | `POST /mcp/call` |
| `list_datasets` | 浏览数据市场 | `POST /mcp/call` |

---

## 🔧 优化建议

### 1. 性能优化

| 优化项 | 当前状态 | 建议 |
|--------|----------|------|
| **MCP 工具响应** | 模拟数据 | 接入真实数据源（Slack API/Jira API 等） |
| **智能合约 Gas** | 未优化 | 使用 Layer2（Polygon/Arbitrum）降低 Gas 费用 |
| **IPFS 上传** | 未实现 | 集成 Pinata/Infura IPFS 服务 |
| **ZK 证明** | 简化实现 | 使用 Circom/SnarkJS 实现真实 ZK 电路 |

### 2. 安全优化

| 优化项 | 当前状态 | 建议 |
|--------|----------|------|
| **智能合约审计** | 未审计 | 联系 CertiK/SlowMist 进行安全审计 |
| **API 认证** | 无 | 添加 API Key + JWT 认证 |
| **速率限制** | 无 | 添加 Express Rate Limit |
| **数据脱敏** | 模拟 | 实现真实 PII 检测和去除（Presidio） |

### 3. 功能优化

| 优化项 | 当前状态 | 建议 |
|--------|----------|------|
| **RL 环境生成** | 模拟 | 实现真实 Gym 环境生成器 |
| **AI 蒸馏引擎** | 未实现 | 训练蒸馏模型（L1-L5 质量等级） |
| **数据市场 UI** | 静态页面 | 开发动态数据市场（搜索/筛选/购买） |
| **钱包集成** | 无 | 集成 MetaMask/RainbowKit |

### 4. 部署优化

| 优化项 | 当前状态 | 建议 |
|--------|----------|------|
| **网站部署** | 本地 | 部署到 Vercel/Netlify |
| **MCP 服务器** | 本地 | 部署到 AWS/GCP + PM2 |
| **智能合约** | 未部署 | 部署到 Polygon 主网 |
| **监控** | 无 | 集成 Sentry + Prometheus |

### 5. 业务优化

| 优化项 | 当前状态 | 建议 |
|--------|----------|------|
| **清算合作** | 无 | 对接 SimpleClosure/Sunset 等清算公司 |
| **数据供给** | 无 | 签约首批 10 家倒闭公司 |
| **AI 客户** | 无 | 联系 Anthropic/OpenAI/Meta |
| **融资** | 计划中 | 准备 Pitch Deck，启动种子轮 |

---

## 📈 路线图

### Phase 1（2026 Q2-Q3）- MVP
- [x] 项目规划和文档
- [x] MCP 服务器开发
- [x] 智能合约开发
- [x] 业务展示页面
- [ ] 真实数据源接入
- [ ] 智能合约部署到测试网
- [ ] 种子轮融资 $200 万

### Phase 2（2026 Q4-2027 Q1）- 产品化
- [ ] RL 环境自动生成工具
- [ ] AI 蒸馏引擎
- [ ] 数据市场 UI
- [ ] A2A 支付系统集成
- [ ] A 轮融资 $1000 万

### Phase 3（2027 Q2-Q4）- 规模化
- [ ] 200+ RL 环境
- [ ] Anthropic/OpenAI 合作
- [ ] B 轮融资 $5000 万

---

## 📞 联系方式

- 📧 邮箱: hello@cyber-recycle.io
- 🌐 网站: https://cyber-recycle.io（待上线）
- 💬 Discord: discord.gg/cyber-recycle（待开放）
- 🐦 Twitter: @CyberRecycle（待开通）

---

## 📄 许可证

MIT License

---

*最后更新：2026-04-18 | 版本：v1.0*
