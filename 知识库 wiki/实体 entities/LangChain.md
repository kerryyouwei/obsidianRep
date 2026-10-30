---
tags: [实体/产品]
创建日期: 2026-10-30
---

# LangChain

## 事实（均出自 [[RAG技术与应用]]）

- 提供问答链 `load_qa_chain`，其中有 4 种 chain_type（原文 Page 33-35）：

| chain_type | 原理 | 特点与适用 |
|---|---|---|
| stuff | 直接把文档作为 prompt 输入 | 文档拆分较小、一次获取文档较少时调用 LLM 次数也少，能使用 stuff 的就使用这种方式（Page 33-34） |
| map_reduce | 对每个 chunk 做一个 prompt（回答或摘要），然后再合并 | 每个 document 单独处理，可并发调用，但每个文档之间缺少上下文（Page 33-34） |
| refine | 在第一个 chunk 上做 prompt 得到结果，然后合并下一个文件再输出结果 | 能部分保留上下文，token 使用能控制在一定范围（Page 33、35） |
| map_rerank | 对每个 chunk 做 prompt，打个分，根据分数返回最好文档中的结果 | 会大量调用 LLM，每个 document 独立处理（Page 33、35） |

- 在 DeepSeek + Faiss 案例中使用：`langchain_community.vectorstores.FAISS`、`DashScopeEmbeddings`、`load_qa_chain`（stuff 策略）、`get_openai_callback` 跟踪成本。（原文 Page 24-30）
- 迪士尼案例不依赖 LangChain，直接使用底层 API。（原文 Page 40）

## 关联

- 应用概念：[[检索增强生成 RAG]]；配合 [[FAISS]] 使用。
