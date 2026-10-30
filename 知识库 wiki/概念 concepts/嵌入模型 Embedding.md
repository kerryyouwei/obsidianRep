---
tags: [概念]
创建日期: 2026-10-30
aliases: [Embedding模型, Embedding, 文本嵌入模型]
---

# 嵌入模型 Embedding

## 事实（均出自 [[RAG技术与应用]]）

### 作用

将文本块转换为向量，存储在向量数据库中，供检索阶段进行相似度搜索。（原文 Page 6）

### 选型参考

HuggingFace MTEB 榜单（https://huggingface.co/spaces/mteb/leaderboard）比较了 1000 多种语言中的 100 多种文本嵌入模型；完整榜单见原文附件 Embedding榜单-202503.csv。（原文 Page 11）

### 常见模型四分类（原文 Page 12-13）

| 类别 | 模型 | 要点 |
|---|---|---|
| 通用文本嵌入 | [[BGE-M3]]（智源研究院） | 100+ 语言、8192 tokens、密集/稀疏/多向量混合检索，适合跨语言长文档检索，2.3G |
|  | text-embedding-3-large（OpenAI） | 向量维度 3072，长文本语义捕捉能力强，英文表现优秀，适合英文优先的全球化应用 |
|  | Jina-embeddings-v2-small（Jina AI） | 参数量仅 35M，支持实时推理（RT<50ms），适合轻量化部署 |
| 中文嵌入 | xiaobu-embedding-v2 | 针对中文语义优化，语义理解能力强，适合中文文本分类、语义检索 |
|  | M3E-Base | 针对中文优化的轻量模型，适合本地私有化部署，0.4G，适用中文法律、医疗领域检索 |
|  | stella-mrl-large-zh-v3.5-1792 | 处理大规模中文数据能力强，捕捉细微语义关系 |
| 指令驱动与复杂任务 | gte-Qwen2-7B-instruct（阿里巴巴） | 基于 Qwen 大模型微调，支持代码与文本跨模态检索，适合复杂指令驱动任务、智能问答系统 |
|  | E5-mistral-7B（Microsoft） | 基于 Mistral 架构，Zero-shot 任务表现优异，适合动态调整语义密度的复杂系统 |
| 企业级与复杂系统 | BGE-M3、E5-mistral-7B | 企业级部署、混合检索/指令微调 |

### gte-Qwen2 补充（原文 Page 19）

gte-Qwen2-7B-instruct 是基于 Qwen2 的指令优化型嵌入模型：经过大量指令-响应对训练，指令理解和执行能力强；在文本生成、问答、分类、情感分析、命名实体识别和语义匹配等任务中表现优异；多语言支持。局限：计算资源需求较高，适合资源充足的环境。

### 案例中的实际选择

- DeepSeek + Faiss 案例：阿里云 DashScope 的 text-embedding-v1。（原文 Page 22）
- 迪士尼案例：text-embedding-v4，1024 维（阿里云百炼），支持可变维度。（原文 Page 40、46、70）

## 关联

- [[检索增强生成 RAG]]、[[BGE-M3]]、[[CLIP]]、[[FAISS]]
