# 赛博回收 - 部署指南

> **版本**: v1.0  
> **创建时间**: 2026-04-17

---

## 📦 项目结构

```
cyber-recycle/
├── website/                    # 独立站（Next.js）
│   ├── package.json
│   ├── src/
│   │   ├── app/
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx
│   │   │   └── globals.css
│   │   └── components/
│   └── public/
│
├── mcp-integration/            # MCP 集成方案
│   └── README.md
│
├── skill-integration/          # Skill 集成方案
│   └── SKILL.md
│
└── docs/                       # 项目文档
    ├── 商业计划书.md
    ├── 技术架构.md
    └── roadmap.md
```

---

## 🚀 网站部署

### 方式 1：Vercel 部署（推荐）

**步骤：**

1. **安装 Vercel CLI**
```bash
npm install -g vercel
```

2. **登录 Vercel**
```bash
vercel login
```

3. **部署**
```bash
cd website
vercel --prod
```

4. **配置域名**
- 在 Vercel Dashboard 添加域名 `cyber-recycle.io`
- 配置 DNS 记录
- 启用 HTTPS

**预计时间：** 10 分钟

---

### 方式 2：自建服务器部署

**步骤：**

1. **构建项目**
```bash
cd website
npm install
npm run build
```

2. **启动服务**
```bash
npm start
# 默认端口：3000
```

3. **配置 Nginx 反向代理**
```nginx
server {
    listen 80;
    server_name cyber-recycle.io;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

4. **配置 SSL（Let's Encrypt）**
```bash
sudo certbot --nginx -d cyber-recycle.io
```

**预计时间：** 30 分钟

---

## 🔧 MCP 服务器部署

### 步骤 1：创建 MCP 服务器

```bash
# 创建 MCP 服务器项目
mkdir mcp-server
cd mcp-server
npm init -y
npm install @anthropic-ai/mcp express
```

### 步骤 2：实现 MCP 工具

创建 `server.js`：

```javascript
const { McpServer } = require('@anthropic-ai/mcp');
const express = require('express');

const server = new McpServer({
  name: 'cyber-recycle',
  version: '1.0.0'
});

// 注册工具
server.tool('collect_data', async (params) => {
  // 实现数据采集逻辑
  return { result: '...' };
});

server.tool('distill_dataset', async (params) => {
  // 实现蒸馏逻辑
  return { result: '...' };
});

// 启动服务器
server.run({
  transport: 'http',
  port: 8080
});
```

### 步骤 3：部署 MCP 服务器

```bash
# 使用 PM2 管理进程
npm install -g pm2
pm2 start server.js --name cyber-recycle-mcp
pm2 save
pm2 startup
```

---

## 🤖 Skill 部署

### 步骤 1：打包 Skill

```bash
# 使用 skill-creator 打包
python ~/.workbuddy/skills/skill-creator/scripts/package_skill.py \
  ./cyber-recycle/skill-integration
```

### 步骤 2：发布到 Skill Hub

```bash
# 登录 Skill Hub
skillhub login

# 发布 Skill
skillhub publish ./cyber-recycle.skill \
  --name "cyber-recycle" \
  --description "赛博回收集成工具"
```

### 步骤 3：测试 Skill

```bash
# 安装测试
skillhub install cyber-recycle

# 运行测试
skillhub test cyber-recycle
```

---

## 📊 监控与日志

### 使用 Sentry 错误监控

```bash
npm install @sentry/nextjs
npx @sentry/wizard@latest -i nextjs
```

配置 `sentry.client.config.js`：

```javascript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  tracesSampleRate: 1.0,
});
```

### 使用 Prometheus 监控

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'cyber-recycle'
    static_configs:
      - targets: ['localhost:3000']
    metrics_path: '/api/metrics'
```

---

## 🔐 安全配置

### 环境变量

创建 `.env.local`：

```bash
# API 配置
NEXT_PUBLIC_API_URL=https://api.cyber-recycle.io
API_KEY=your_api_key

# 钱包配置
WALLET_PRIVATE_KEY=0x...
NETWORK=polygon

# Sentry 配置
SENTRY_DSN=https://...

# 数据库配置
DATABASE_URL=postgresql://...
```

### 速率限制

```javascript
// middleware.ts
import { rateLimit } from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 分钟
  max: 100, // 最多 100 次请求
  message: 'Too many requests'
});

app.use('/api/', limiter);
```

---

## 📈 性能优化

### 1. 图片优化

```bash
# 安装 next/image
npm install next
```

在组件中使用：

```tsx
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Hero"
  width={1920}
  height={1080}
  priority
/>
```

### 2. 代码分割

```tsx
// 动态导入
const DataMarket = dynamic(() => import('@/components/DataMarket'), {
  ssr: false,
  loading: () => <p>Loading...</p>
});
```

### 3. CDN 配置

使用 Vercel Edge Network 或 Cloudflare：

```javascript
// next.config.js
module.exports = {
  images: {
    domains: ['cdn.cyber-recycle.io']
  }
};
```

---

## 🎯 上线检查清单

### 网站
- [ ] 域名配置完成
- [ ] SSL 证书启用
- [ ] 所有页面加载正常
- [ ] 移动端适配测试通过
- [ ] SEO 元数据配置
- [ ] Analytics 集成
- [ ] 错误监控集成

### MCP 服务器
- [ ] 所有工具测试通过
- [ ] API 认证配置
- [ ] 速率限制启用
- [ ] 日志记录配置
- [ ] 健康检查端点

### Skill
- [ ] Skill Hub 发布成功
- [ ] 安装测试通过
- [ ] 所有工具测试通过
- [ ] 文档完整

### 安全
- [ ] 环境变量配置
- [ ] API Key 轮换策略
- [ ] DDoS 防护
- [ ] 数据备份策略

---

## 🆘 故障排查

### 网站无法访问

```bash
# 检查服务状态
pm2 status

# 查看日志
pm2 logs cyber-recycle

# 重启服务
pm2 restart cyber-recycle
```

### MCP 连接失败

```bash
# 测试端点
curl https://api.cyber-recycle.io/health

# 检查认证
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://api.cyber-recycle.io/api/v1/datasets
```

---

## 📞 支持

- 📧 技术支持：dev@cyber-recycle.io
- 💬 Discord：discord.gg/cyber-recycle
- 📖 文档：docs.cyber-recycle.io

---

*文档版本：v1.0 | 最后更新：2026-04-17*
