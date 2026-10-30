---
tags: [实体/产品]
创建日期: 2026-10-30
aliases: [Faiss]
---

# FAISS

## 事实（均出自 [[RAG技术与应用]]）

- 向量数据库/库，作为向量检索引擎的核心，性能极高。（原文 Page 40）
- 注意：在生产环境中，可以使用 Milvus、ChromaDB 或 Elasticsearch，它们提供了完整数据管理服务。（原文 Page 40）

## 原文中的用法

### DeepSeek + Faiss 案例（Page 22-30）

- 用 `langchain_community.vectorstores.FAISS` 存储文本向量，支持高效相似度搜索；用 `FAISS.from_texts(chunks, embeddings)` 创建知识库。（原文 Page 26、30）
- 数据持久化：保存 Faiss 索引文件（.faiss）、元数据信息（.pkl）、页码映射关系（page_info.pkl）。（原文 Page 24）
- 为每个文本块保存对应页码信息，实现查询结果溯源。（原文 Page 30）

### 迪士尼案例（Page 70）

- 双索引系统：FAISS 分别构建文本和图像的向量索引（文本 1024 维、图像 512 维）。（原文 Page 70）

## 关联

- 应用概念：[[检索增强生成 RAG]]、[[混合检索]]、[[多模态RAG]]
