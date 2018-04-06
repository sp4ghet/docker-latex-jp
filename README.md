日本語が使えるLatexイメージ on Docker
===

upLaTeX+dvipdfmxでtexソースファイルをPDFに変換するためのDockerコンテナ。日本語フォントとして[源真ゴシック](http://jikasei.me/font/genshin/)と[源樣明體](https://github.com/ButTaiwan/genyo-font)を埋め込む。

## Installation

```bash
docker pull ganow/latex-jp:0.2
```

## Usage

基本的な使用方法は以下の通り:

```bash
docker run --rm -it -v [/path/to/src/directory]:/home/alpine/src latexmk [filename].tex
```

例えば、LaTeXソースの置いてあるMakefileに

```Makefile
...
watch:
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	latexmk -pvc -jobname=${BUILD_DIR}/${JOBNAME} ${TEX}
...
```

と書いてあるとする。これを以下のように書き換えれば動く:

```Makefile
IMAGETAG=0.2
REPOSITORY=ganow/latex-jp
IMAGENAME=$(REPOSITORY):$(IMAGETAG)
...
watch:
	@[ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR)
	docker docker run --rm -it \
		-v $(PWD):/home/alpine/src $(IMAGENAME) \
		latexmk -pvc -jobname=${BUILD_DIR}/${JOBNAME} ${TEX}
...
```

## 参考

- [日本語が扱える alpine の LaTeX イメージを作った話](http://3846masa.hatenablog.jp/entry/2017/02/08/215920)
- [upLaTeX文書で源ノ明朝／Noto Serif CJKを簡単に使う方法（最新のdvipdfmxとpxchfonを使用）](https://qiita.com/zr_tex8r/items/9dfeafecca2d091abd02)
- [(u)pLaTeXのデフォルトの日本語フォントを好きなやつに変える方法](https://qiita.com/zr_tex8r/items/15ec2848371ec19d45ed)
