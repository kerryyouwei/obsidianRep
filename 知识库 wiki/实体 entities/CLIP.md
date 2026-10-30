---
tags: [实体/产品]
创建日期: 2026-10-30
---

# CLIP

## 事实（均出自 [[RAG技术与应用]]）

- 由 OpenAI 开发，能同时理解图片和文本，是[[多模态RAG]]的核心。（原文 Page 40）
- 在迪士尼 RAG 助手案例中用作图像 Embedding 模型：CLIP ViT-Base-Patch32，向量 512 维，适用跨模态检索。（原文 Page 47）
- CLIP 文本编码器可生成与图像向量在同一空间的文本向量，用于文本到图像的检索（查询图片时用 CLIP 文本向量在图像索引中搜索）。（原文 Page 47、48）
- 图像检索中，文本查询向量通过 `clip_processor` + `clip_model.get_text_features` 生成，图像向量通过 `clip_model.get_image_features` 生成。（原文 Page 47）

## 关联

- 应用案例：[[多模态RAG]]（迪士尼 RAG 助手）
- 相关概念：[[混合检索]]、[[嵌入模型 Embedding]]
