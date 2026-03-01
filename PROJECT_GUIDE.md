# Nuxt 4 + Nuxt Content v3 项目深度解析文档

本文档旨在帮助开发者深入理解本项目（基于 Nuxt 4 构建的现代化作品集/博客系统）的架构设计、核心技术实现及面试应对策略。

## 1. 目录结构详解 (Directory Structure)

本项目采用 **Nuxt 4** 推荐的 `app/` 目录结构，将应用源码与配置文件分离，结构更加清晰。

| 目录/文件 | 说明 | 核心作用 |
| :--- | :--- | :--- |
| **`app/`** | **应用源码根目录** | Nuxt 4 新特性。存放所有 Vue 组件、页面和逻辑。 |
| ├── `components/` | 组件目录 | 自动导入的 Vue 组件。如 `AppHeader.vue`, `LanguageSelector.vue`。 |
| ├── `pages/` | 页面路由 | 基于文件的路由系统。`index.vue` -> `/`, `about.vue` -> `/about`。 |
| ├── `layouts/` | 布局文件 | 页面通用外壳（如页眉页脚）。`default.vue` 是默认布局。 |
| ├── `utils/` | 工具函数 | 自动导入的辅助函数。如 `links.ts` (导航链接配置)。 |
| ├── `app.config.ts` | **运行时配置** | **响应式**配置。用于 UI 主题、图标、公共变量等，客户端可访问。 |
| ├── `app.vue` | 应用入口 | 根组件，通常包含 `<NuxtLayout>` 和 `<NuxtPage>`。 |
| **`content/`** | **内容数据源** | **Nuxt Content v3** 的核心。存放 Markdown/YAML/JSON 数据。 |
| ├── `blog/` | 博客文章 | `.md` 文件，会被解析为文章页面。 |
| ├── `*.yml` | 数据集合 | 如 `about.yml`, `projects.yml`，存储结构化数据。 |
| **`content.config.ts`** | **内容配置** | **v3 新特性**。使用 Zod 定义数据 Schema，提供强类型支持。 |
| **`nuxt.config.ts`** | **构建时配置** | 项目构建配置。包括模块 (`modules`)、SSR 规则、环境变量等。 |
| **`public/`** | 静态资源 | 存放 `favicon.ico`, `robots.txt` 等不经编译的静态文件。 |

---

## 2. 核心 API 与技术栈解析

### 2.1 Nuxt Content v3 (核心亮点)

本项目使用最新的 Content v3，与 v2 有本质区别。

*   **核心 API**: `queryCollection(collectionName)`
    *   **作用**: 查询 `content.config.ts` 中定义的集合数据。
    *   **代码示例**:
        ```ts
        // app/pages/about.vue
        const { data } = await useAsyncData('about', () => {
          return queryCollection('about').first()
        })
        ```
    *   **特点**: 基于 SQL (SQLite) 查询，性能更强；配合 Zod Schema 实现完全的类型安全。

*   **核心配置**: `defineContentConfig` & `defineCollection`
    *   **作用**: 在 `content.config.ts` 中严格定义数据结构。
    *   **代码示例**:
        ```ts
        export default defineContentConfig({
          collections: {
            blog: defineCollection({
              type: 'page',
              source: 'blog/*.md',
              schema: z.object({ title: z.string(), date: z.date() }) // Zod 验证
            })
          }
        })
        ```

### 2.2 Nuxt UI & Tailwind CSS v4

*   **技术**: 使用 `@nuxt/ui` (基于 Tailwind CSS v4)。
*   **特点**: v4 引擎重写，构建速度极快，无需 `tailwind.config.js`，直接在 CSS 中配置。
*   **组件**: 如 `<UButton>`, `<UDropdownMenu>`，提供了一套高质量、可定制的 UI 组件库。

### 2.3 数据获取与状态

*   **API**: `useAsyncData`
    *   **作用**: 在 SSR 过程中处理异步数据获取，防止客户端重复请求（Hydration Mismatch）。
    *   **场景**: 获取 CMS 内容、API 请求。

### 2.4 国际化 (i18n)

*   **模块**: `@nuxtjs/i18n`
*   **实现**: 配置 `locales` (en, zh)，使用 `useI18n()` 钩子切换语言。

---

## 3. 应用场景 (Application Scenarios)

1.  **个人作品集 (Portfolio)**:
    *   利用 `content/projects` 管理项目展示，YAML 格式易于维护。
    *   利用 Nuxt UI 快速搭建高颜值界面。
2.  **技术博客 (Tech Blog)**:
    *   Markdown (MDC) 支持代码高亮、组件嵌入。
    *   SSG (静态站点生成) 部署到 Vercel/Netlify，SEO 友好且免费。
3.  **文档站点**:
    *   结构化内容管理，多语言支持。

---

## 4. 面试高频问题与回答指南

### Q1: 这个项目的目录结构为什么和传统的 Nuxt 3 不一样？(关于 `app/` 目录)
*   **回答**: "这是一个 Nuxt 4 风格的项目结构。Nuxt 4 引入了 `app/` 目录作为默认的应用源码根目录（类似于 Next.js 的 `src/` 或 `app/`），目的是为了将**源码**（pages, components）与**项目配置**（nuxt.config.ts, .github, content, public）在物理上分离，使根目录更加整洁，便于大型项目维护。"

### Q2: Nuxt Content v3 和 v2 有什么主要区别？
*   **回答**: "最大的区别在于**类型安全**和**底层引擎**。
    1.  **Schema 驱动**: v3 引入了 `content.config.ts` 和 Zod Schema，在构建时校验数据结构，提供了完美的 TypeScript 类型提示，避免了 v2 中`any`类型的困扰。
    2.  **SQL 引擎**: v3 底层使用 SQLite 存储和查询内容，支持更复杂的 SQL 查询，性能比 v2 的文件系统遍历更好。
    3.  **API 变化**: 使用 `queryCollection` 替代了 `queryContent`。"

### Q3: `nuxt.config.ts` 和 `app.config.ts` 有什么区别？
*   **回答**:
    *   `nuxt.config.ts` 是**构建时配置**。用于安装模块、配置 Vite/Nitro、设置环境变量等。修改它通常需要重启服务器。
    *   `app.config.ts` 是**运行时配置**（Reactive）。主要用于 UI 主题配置、图标集定义、公开的常量。它是响应式的，修改后支持 HMR（热更新），且可以在客户端代码中直接通过 `useAppConfig()` 访问，无需重新构建。"

### Q4: 为什么选择 Tailwind CSS v4？它解决了什么问题？
*   **回答**: "v4 是 Tailwind 的一次重大重写。
    1.  **性能**: 使用 Rust (Oxywind) 重写了引擎，构建速度提升显著。
    2.  **零配置**: 不再依赖 `postcss.config.js` 或庞大的 `tailwind.config.js`，所有配置（如主题扩展）都可以直接在 CSS 文件中通过 `@theme` 指令完成。
    3.  **即时编译**: 更加智能的按需编译，减小了产物体积。"

### Q5: 项目中的 `useAsyncData` 是做什么的？可以直接用 `fetch` 吗？
*   **回答**: "在 Nuxt 的 SSR 环境下，不能直接在组件 setup 中使用原生 `fetch`。
    *   直接用 `fetch` 会导致服务端执行一次请求，客户端水合（Hydration）时又执行一次，造成**双重请求**。
    *   `useAsyncData` (或 `useFetch`) 会在服务端获取数据后，将数据序列化传输给客户端（Payload），客户端直接复用该数据，避免重复请求，并处理了 SSR 过程中的异步等待问题。"
