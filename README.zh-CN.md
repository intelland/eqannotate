# EqAnnotate

[English](README.md) | 简体中文

[![CI](https://github.com/intelland/eqannotate/actions/workflows/ci.yml/badge.svg)](https://github.com/intelland/eqannotate/actions/workflows/ci.yml)
[![最新版本](https://img.shields.io/github/v/release/intelland/eqannotate)](https://github.com/intelland/eqannotate/releases/latest)
[![许可证：MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**面向 LaTeX 的声明式公式标注与自动布局工具。**

> 告诉 EqAnnotate 要标注什么，而不是标签应该放在哪里。

EqAnnotate 是一个为带标注行间公式提供自动布局的 LaTeX 宏包。标记数学项并声明标签后，宏包会处理位置、换行、间距、避让、分层和连接线路由。

<p align="center">
  <img src="docs/images/hero-complex.png"
       alt="EqAnnotate 围绕多项损失函数自动安排四个标注"
       width="900">
</p>

EqAnnotate 让源代码聚焦于数学含义，同时自动安排一组密集的公式标注。

```latex
\begin{annotatedequation}
\mathcal{L}(\theta)
=
\eqmark[blue]{rec}{\lambda_{\mathrm{rec}}\mathcal{L}_{\mathrm{rec}}}
+
\eqmark[orange]{adv}{\lambda_{\mathrm{adv}}\mathcal{L}_{\mathrm{adv}}}
+
\eqmark[green]{cyc}{\lambda_{\mathrm{cyc}}\mathcal{L}_{\mathrm{cyc}}}
+
\eqmark[purple]{reg}{\lambda_{\mathrm{reg}}\|\theta\|_2^2}

\eqannotate{rec}{Reconstruction fidelity}
\eqannotate{adv}{Adversarial realism}
\eqannotate{cyc}{Cycle consistency}
\eqannotate{reg}{Regularization}
\end{annotatedequation}
```

## 同样的标注意图，更少的空间决策

<p align="center">
  <img src="docs/images/layout-comparison.png"
       alt="同一组四标签公式在低层公式标注工作流与 EqAnnotate 中的对比"
       width="1000">
</p>

[`annotate-equations`](https://github.com/st--/annotate-equations) 提供了方便的 TikZ 公式标注工作流，也是 EqAnnotate 的直接基础。EqAnnotate 将常见工作流提升到更高的抽象层次：调用者声明目标和标签，布局器处理位置、换行、避让、分层、列边界和连接线路由。

核心区别在于抽象层次：EqAnnotate 保持常见标注工作流的声明式表达，由布局器处理位置和路由。

## 对作者和 Agent 的意义

对作者而言，更少的坐标微调意味着更短、更容易维护的 LaTeX 源码，也让整篇文档的标注风格更一致。

对 Codex、Claude Code 等编程和写作 Agent 而言，重要的决策在语义层面：哪些项重要、它们表示什么、标签如何表述。位置、分层和连接线路由属于二维布局任务，由 EqAnnotate 处理。

> 在通常用法中，人和 Agent 都只说明一个公式项的含义；EqAnnotate 决定标注放在哪里。

可选的 [EqAnnotate Agent Skill](skills/eqannotate/SKILL.md) 为 Codex、Claude Code 等工作流提供自动布局、收敛检查和手动放置指导。EqAnnotate 本身是 LaTeX/TikZ 宏包；Agent Skill 为可选项。

## 发布信息

- 当前稳定版本：v0.1.1
- 许可证：MIT
- 依赖：LaTeX2e、amsmath、xcolor、TikZ/tikzmark、expl3/xparse
- 已测试引擎：pdfLaTeX、LuaLaTeX、XeLaTeX
- 仓库：https://github.com/intelland/eqannotate
- Issues：https://github.com/intelland/eqannotate/issues
- 正式手册：[eqannotate.pdf](eqannotate.pdf)

## 安装

### Overleaf 或本地项目

1. 从[最新 GitHub Release 下载 `eqannotate.sty`](https://github.com/intelland/eqannotate/releases/latest/download/eqannotate.sty)。
2. 将文件上传或复制到 `main.tex` 所在目录。
3. 正常加载：

```latex
\usepackage{eqannotate}
```

更多安装方式见[安装说明](docs/installation.md)，完整用法见[用户指南](docs/usage.md)。

## 核心接口

```latex
\eqmark[<color>]{<id>}{<math>}
\eqannotate[prefer=auto|above|below]{<id>}{<label>}

\eqannotatecolortheme{colorful} % 或 mono
\eqannotatecalloutstyle{leader} % 或 arrow
```

支持 `annotatedequation`、`annotatedalign`、`annotatedgather` 和 `annotatedmultline` 四种行间公式环境，每种都可使用可选的 `[numbered]`。

如需只对一项标注进行直接控制，可使用：

```latex
\eqannotatemanual[xshift=12mm,yshift=10mm][bend right=18]
  {velocity}{速度场}
```

自动标签会测量并换行，适应当前 `\linewidth`，为正文预留空间，并在公式外布线。手动标签保留活动主题、引出线样式、遮罩和空间预留。

## 路线图

- [ ] 行内公式标注
- [ ] 更丰富的多行编号
- [ ] 自定义 `\tag`
- [ ] 多行环境中的 `\intertext` / `\shortintertext`
- [ ] 更好的非白色背景处理
- [ ] CTAN 发布

如需使用彩色页面，请将 `\eqannotatebackgroundcolor` 设置为页面颜色。

## 文档

- [正式手册](eqannotate.pdf)
- [安装说明](docs/installation.md)
- [用户指南](docs/usage.md)
- [公开 API 合约](docs/api-contract.md)
- [布局设计](docs/layout.md)
- [验证说明](docs/validation.md)

## 致谢

EqAnnotate 建立在 [`annotate-equations`](https://github.com/st--/annotate-equations) 展示的公式标注工作流与 TikZ 技术之上，并增加了低配置的自动布局层。

[`annotated_latex_equations`](https://github.com/synercys/annotated_latex_equations) 的彩色公式标注示例为本项目的视觉表达提供了启发。[`ScholarPhi`](https://github.com/allenai/scholarphi) 为分离标签测量、布局和引线生成提供了工程参考。

感谢 PGF/TikZ、`tikzmark` 与 `amsmath` 等 LaTeX 生态项目。

## 开发

```bash
./tests/run.sh
./tests/compatibility/run.sh
```

两套测试都会运行至布局状态收敛。

## 许可证

MIT，见 [LICENSE](LICENSE)。
