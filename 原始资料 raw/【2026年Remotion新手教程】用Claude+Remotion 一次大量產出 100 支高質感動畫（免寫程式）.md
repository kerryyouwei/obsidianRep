---
title: "【2026年Remotion新手教程】用Claude+Remotion 一次大量產出 100 支高質感動畫（免寫程式）"
source: "https://www.youtube.com/watch?v=XB23PD8IZA0"
author:
  - "[[YAHA学堂]]"
published: 2026-04-18
created: 2026-11-01
description: "外包一支5000塊，AE開三小時，Canva套模板翻來覆去就那幾種——這支影片教你用 Claude Code 配 Remotion，十分鐘做一支專業影片，最後還能一次批量100支，全程零程式碼零剪輯。我從建專案到批量輸出MP4的完整工作流全部拆給你看，包括我自己踩過的那個「改模糊prompt會爆炸」的坑。影片中提到的工具：- Claude Code（官方下載）：https://claud"
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=XB23PD8IZA0)

外包一支5000塊，AE開三小時，Canva套模板翻來覆去就那幾種——這支影片教你用 Claude Code 配 Remotion，十分鐘做一支專業影片，最後還能一次批量100支，全程零程式碼零剪輯。  
  
我從建專案到批量輸出MP4的完整工作流全部拆給你看，包括我自己踩過的那個「改模糊prompt會爆炸」的坑。  
  
影片中提到的工具：  
\- Claude Code（官方下載）：https://claude.com/claude-code  
\- Remotion 官方文件：https://www.remotion.dev/  
\- Remotion Claude Code Skills：https://www.remotion.dev/docs/ai/skills  
\- Node.js（18以上）：https://nodejs.org/  
\- CleanShot X（長截圖工具）：https://cleanshot.com/  
  
時間軸：  
00:00 一行程式碼都沒寫，靠對話做出專業動畫  
00:17 建專案＋裝 Skills：選錯這一步後面會 debug 30 分鐘  
01:52 第一支影片：一句中文生出 30 秒教育動畫  
03:04 模糊 prompt 的陷阱——我一開始就踩過  
04:06 進階實戰：丟一個網站 URL 就換一支產品展示影片  
05:40 殺手級功能：一次批量生成 100 支影片的 JSON 工作流  
07:04 渲染 MP4 ＋批量輸出，你去吃個飯回來就跑完了  
\---  
這支影片講的不是「AI工具推薦」，而是一套可以真正取代外包設計師的工作流。Remotion 是 Netflix、Meta 內部都在用的程式化影片框架，最近因為 Remotion 官方推出的 Claude Code Agent Skills 爆紅（Threads 上一篇介紹貼文拿到1300萬曝光），現在只要會用中文講話，就能叫 Claude 幫你寫程式碼生影片。  
  
這支教學特別花時間示範一個陷阱：當你打「把影片改好看一點」這種模糊 prompt，Claude 會過度發揮，新建四個檔案、改整套風格。具體的 prompt 得到你要的，模糊的 prompt 得到 Claude 猜的——這段的教訓可能比所有工具教學都重要。  
  
第5段的批量工作流是整支影片的隱藏大招。一個 JSON 檔 = 一支影片，100 個 JSON = 100 支影片，還可以接試算表、接資料庫、接公司 CMS 自動產生。產品上架自動產 Reels、課程更新自動產教學片，全程沒人碰鍵盤——這才是程式化影片真正改變遊戲規則的地方。  
  
下一支影片我會教怎麼在這個工作流加上 AI 語音配音，做出完全自動化的教學片生產線。訂閱起來才不會錯過。  
  
#ClaudeCode #Remotion #AI影片生成 #自動化工作流 #YouTube教學  
  
💬 你打算用這個工作流做什麼主題？是教學、產品展示，還是拍 Reels？留言告訴我，我挑幾個在下一支影片示範給你看。  
  
關於這個頻道：  
每週一支 AI 工具實戰教學，專做「用 AI 自動化真實工作流程」。不講理論、不介紹工具清單，只示範一個可以直接搬到你工作上的完整流程。

## Transcript

### 一行程式碼都沒寫，靠對話做出專業動畫

**0:00** · The animation you're seeing, I didn't write a single line of code for it.

**0:03** · I never even opened any editing software.

**0:05** · I completed everything just by talking to AI.

**0:08** · Hiring a freelancer would cost at least $5,000.

**0:10** · Today I'll teach you how to use Claude Code with Remotion for free.

**0:13** · You can create it in just 10 minutes.

**0:15** · And in the end, you can even generate 100 videos in bulk at once.

### 建專案＋裝 Skills：選錯這一步後面會 debug 30 分鐘

**0:17** · Before the video starts, your computer needs to have Node.js version 18 or above installed, as well as Claude Code.

**0:23** · If you haven't installed them, you'll find the links in the description.

**0:26** · It only takes 30 seconds to set up.

**0:27** · Once you've prepared these essentials, Use npx to initialize the project.

**0:31** · You can see that Remotion provides many templates.

**0:35** · There are templates for Next.js.

**0:37** · There are also ones for React.

**0:38** · I’ll choose a blank template to start from scratch.

**0:41** · Here it asks whether to add Tailwind CSS.

**0:45** · Select Yes.

**0:46** · If you don’t choose it, the final result won’t look as good.

**0:49** · Then it asks whether to add Agent Skills.

**0:52** · That’s definitely a yes.

**0:53** · It will clone the Skills from GitHub.

**0:56** · Then it asks which ones you want to install.

**0:58** · I don’t want to install all of them, so I choose to specify the agents I need.

**1:02** · I chose the commonly used Claude Code and Codex.

**1:05** · Use the space bar here to navigate.

**1:06** · Press Enter to confirm your selection.

**1:09** · Make sure the Skill is installed in the current project.

**1:12** · Or choose a global installation instead.

**1:13** · If installed globally, it can be used across all projects.

**1:16** · I don't have that need.

**1:17** · So I'll choose Project.

**1:19** · Just go with the recommended installation option.

**1:21** · Then select Yes to start the installation.

**1:23** · It will finish installing in just a few seconds.

**1:25** · After that, you'll see this.

**1:26** · It tells us what to do next.

**1:29** · First, open a session to run these two commands.

**1:32** · First, install the required dependencies.

**1:34** · Once it's done, you'll see this prompt.

**1:37** · Finally, use the npm command to run it locally.

**1:41** · It will provide you with a link.

**1:42** · Click it to open Remotion Studio.

**1:46** · When you see this screen, you're halfway there.

**1:48** · Next is the code written by Claude.

**1:50** · You can preview it here in real time.

### 第一支影片：一句中文生出 30 秒教育動畫

**1:52** · Now let's make the first video.

**1:54** · Just one sentence.

**1:55** · Let's see what Claude Code can create.

**1:58** · Look at its workflow.

**2:00** · First, it reads the rules.

**2:01** · Then it writes the code.

**2:02** · Finally tested it myself He created three files Scene components and SVG icon animations And the timeline arrangement for the main video He handled everything on his own A little over two minutes You don't have to do anything So I opened Remotion Studio Now you can see the project list on the left There's an additional item called "AI Agent Explainer" Click the Play button Preview the actual result A 30-second educational animation Five scenes There are fade transitions.

**2:31** · There are SVG icon animations.

**2:33** · And a progress bar.

**2:34** · From start to finish.

**2:35** · You didn’t write a single line of code.

**2:37** · This video itself is well made.

**2:40** · But with videos like this, it’s a different story.

**2:41** · They’re never truly finished.

**2:42** · Today you want to change the colors to match your channel’s style.

**2:46** · Tomorrow you want to add a logo.

**2:47** · The day after, you want to swap out an icon.

**2:49** · What should you do? Just have Claude make the changes.

**2:53** · Yes, it’s that simple.

**2:54** · He understands as long as you speak Chinese to him.

**2:56** · He will follow your instructions and make three revisions.

**2:59** · All you need to do is wait.

**3:01** · Once the edits are done, the entire video will have a different style.

### 模糊 prompt 的陷阱——我一開始就踩過

**3:04** · But next, I’m going to demonstrate a trap you’ll definitely encounter— one that I fell into at the very beginning.

**3:10** · You already know how to use specific prompts, but sometimes you’re just lazy, or you haven’t clearly thought through what you want to change.

**3:17** · You can’t help but type a line like, "Make the video look better," It sounds convenient, doesn’t it?

**3:23** · Let me show you what happens.

**3:26** · See? The visuals really do look better.

**3:28** · There are particles in the background.

**3:30** · The icons have a glow effect.

**3:31** · The Subscribe button even has a breathing animation.

**3:34** · Claude is actually very smart.

**3:35** · He really does make things look better for you.

**3:38** · But today I just want to quickly change a color.

**3:40** · I’m not asking him to redesign the entire video.

**3:43** · He created four new files.

**3:45** · And the style might not even be what I want.

**3:47** · If I need to tweak it again next time, the amount of work to go through will triple.

**3:50** · So remember, Be specific when asking for changes.

**3:53** · It's not that Claude makes mistakes, it's that you weren't clear.

**3:56** · It will then do it for you.

**3:57** · That's a lot—you've already learned half of it.

**4:00** · But everything before this was just the basics.

**4:02** · The next two tips are where you really save time.

### 進階實戰：丟一個網站 URL 就換一支產品展示影片

**4:06** · Just drop a website URL into Claude.

**4:09** · You don't even need to prepare any materials yourself.

**4:11** · See what kind of results it generates.

**4:14** · Look, it automatically grabbed the website's colors and screenshots.

**4:18** · It matched the entire video's color tone to the brand colors.

**4:21** · Then it generated the design.

**4:23** · A one-stop service The final product is ready Let’s take a look first Go back to Remotion Studio There’s an extra Remotion Showcase on the left Select it to preview It’s absolutely stunning In the past, this effect would have taken me a whole day Now it’s done in just a few minutes If Claude tells you he can’t access the internet No problem, just take a screenshot yourself Look at his thought process I only gave him one image and a color code He decided everything else on his own The canvas should be vertical, 9:16.

**4:54** · Perfect for Reels.

**4:55** · Divide it into five parts: Intro, scrolling section, three Highlights, and Outro.

**4:59** · Derive a complete color palette from the brand colors.

**5:02** · 24 seconds, vertical 9:16.

**5:05** · Upload directly to IG Reels or YouTube Shorts.

**5:08** · No watermark.

**5:09** · One screenshot, one color code.

**5:12** · Zero manual intervention.

**5:13** · Swap it for a Reels video ready to publish. Canva template.

**5:16** · No matter how you tweak it, there are only a few variations. Runway.

**5:19** · You can't control the details.

**5:20** · Here, every pixel can be adjusted.

**5:22** · But you don't have to write code yourself.

**5:24** · Claude helps you edit it.

**5:25** · A product showcase video.

**5:27** · A designer would quote at least $5,000.

**5:29** · Now it takes 5 minutes, and it's free.

**5:31** · But that's still making one video at a time.

**5:34** · What if you need to make 100 at once?

**5:36** · There's only one last trick left.

**5:38** · It's the killer feature mentioned at the beginning.

### 殺手級功能：一次批量生成 100 支影片的 JSON 工作流

**5:40** · Remember the bulk video production mentioned earlier?

**5:43** · It's right here—the most powerful thing about Remotion.

**5:46** · The video you create.

**5:48** · Is actually a template.

**5:49** · All the text, colors, and content can be changed.

**5:53** · You don't even need to know what React is.

**5:55** · As for the components, Claude will handle them for you.

**5:57** · Enter this command in Claude Code.

**6:00** · Note one thing.

**6:01** · I didn't tell him what to cover in each topic.

**6:04** · He wrote it himself.

**6:06** · RAG is divided into user query, retrieval, prompt composition, generation, and attribution.

**6:12** · LLM training is divided into pre-training, SFT, RLHF, and deployment.

**6:18** · Each has five scenarios.

**6:19** · Each has its own color scheme.

**6:21** · He decided that himself. Three files.

**6:24** · The settings for three videos.

**6:26** · Each file is the complete blueprint for one video.

**6:29** · Title of the Theme Five Scenes Brand Colors and End Credits Text Want to Change the Copy Want to Change the Colors Just edit the text inside directly No need to touch the code Want to preview the effect of a certain JSON file The fastest way Open that file Select all and copy Paste it into the Props panel on the right side of Remotion Studio You’ll immediately see the changes in the scene on the left If you’re not used to editing directly in JSON You can also switch to the Schema panel.

**6:57** · This way, it looks much cleaner.

**6:59** · You can edit whichever one you want.

**7:02** · Once you edit it, everything updates automatically.

### 渲染 MP4 ＋批量輸出，你去吃個飯回來就跑完了

**7:04** · Rendering—this is where batch processing really shines.

**7:08** · The key command is right here.

**7:09** · The --props flag.

**7:11** · Pass in the path to any JSON file.

**7:14** · Remotion will render using that set of data.

**7:17** · Once you understand this principle, If an error occurs, you'll be able to debug it yourself.

**7:21** · A 30-second video takes about 1 to 3 minutes to generate.

**7:26** · It's simple. What about batch generation?

**7:28** · Just tell Claude directly.

**7:29** · That's all. For example, take the data in the topics folder and render all the JSON files into MP4s, with filenames the same as the JSON filenames.

**7:37** · Claude will run the scripts one by one to generate them.

**7:41** · The generated files will be saved in the output folder.

**7:44** · The three videos are just a demo. If you put 100 JSON files in the topics folder, it will generate 100 videos.

**7:52** · If you do it manually, it would take at least 50 hours.

**7:54** · Now you just need to prepare the template, and drop the data in.

**7:57** · It takes about two to three hours to finish.

**7:59** · You can go grab a meal and come back.

**8:01** · And this JSON file isn’t just for Claude.

**8:05** · You can also connect it to spreadsheets.

**8:07** · Connect it to databases.

**8:08** · Connect it to your company’s CMS.

**8:10** · Automatically generate JSON files.

**8:12** · List products online.

**8:13** · Automatically create Reels, and generate tutorial videos whenever a course is updated.

**8:17** · No one has to touch the keyboard throughout the entire process.

**8:18** · The exported MP4 is in a standard format.

**8:21** · Upload it directly to YouTube.

**8:23** · IG Reels, with no watermark.

**8:25** · From zero to mass-producing videos.

**8:27** · I didn't write a single line of code the entire time.

**8:29** · Now it's your turn.

**8:31** · Pause the video.

**8:32** · Run this command.

**8:33** · Spend 10 minutes creating your first AI animation.

**8:36** · Once you're done with the video.

**8:38** · Tell me in the comments what topic you chose.

**8:41** · What problems you ran into along the way.

**8:42** · Leave a comment and let me know.

**8:44** · I’ll take a look and help you out.

**8:45** · If you see a red error message.

**8:48** · Take a screenshot and send it to Claude first.

**8:50** · He can usually help you fix it.

**8:52** · If you think this episode was pretty good.

**8:54** · Please give me a like.

**8:56** · I’ll also be making another video.

**8:57** · Introducing how to use Remotion with AI voiceovers.

**9:00** · To create fully automated tutorial videos.

**9:03** · Scripts, animations, and voiceovers all fully automated.

**9:05** · You can just lie back and relax.

**9:06** · I publish two to three hands-on AI tool tutorials every week.

**9:10** · Make sure to subscribe so you don’t miss out.

**9:12** · See you in the next video.