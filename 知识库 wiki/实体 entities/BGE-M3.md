---
tags: [实体/产品]
创建日期: 2026-10-30
aliases: [BAAI/bge-m3]
---

# BGE-M3

## 事实（均出自 [[RAG技术与应用]]）

- 智源研究院推出的嵌入模型。（原文 Page 12）
- 特点：支持 100+ 语言，输入长度达 8192 tokens，融合密集、稀疏、多向量混合检索，适合跨语言长文档检索；文件大小 2.3G；适用场景：跨语言长文档检索、高精度 RAG 应用。（原文 Page 12）
- 也被列为企业级与复杂系统模型：适合企业级部署，支持混合检索；适用场景：企业级语义检索、复杂 RAG 应用。（原文 Page 13）

## 使用方式（原文案例，Page 14-15）

```python
from FlagEmbedding import BGEM3FlagModel
model = BGEM3FlagModel('BAAI/bge-m3', use_fp16=True, max_length=8192)
embeddings_1 = model.encode(sentences_1, batch_size=12)['dense_vecs']
```

- `encode` 返回 `dense_vecs`（密集向量）；两组向量的相似度矩阵用矩阵乘法 `embeddings_1 @ embeddings_2.T` 计算（`@` 在 Python 中表示矩阵乘法运算）。（原文 Page 14-15）
- 原文示例结果：「What is BGE M3?」与 BGE M3 的描述句相似度 0.6265（较高），与 BM25 描述句相似度 0.3477（较低）；「Defination of BM25」与两句的相似度分别为 0.3499 和 0.678。（原文 Page 15）

## 关联

- 相关概念：[[嵌入模型 Embedding]]、[[混合检索]]（支持密集、稀疏、多向量混合检索）
