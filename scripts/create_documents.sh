#!/bin/bash

# Erzeugt Derivate vom Master-Dokument (Markdown-Format in /dokument/master/)
# in verschiedenen Ausgabeformaten

SOURCE="*.md"
DOC_FOLDER=".."
PWD=`pwd`
PDFLATEX="/usr/local/texlive/2012basic/bin/universal-darwin/pdflatex"

GS="/usr/local/bin/gs"

cd dokument/master

echo "Generiere PNG aus PDF-Abbildungen"
for f in images/*.pdf
do
	$GS -dQUIET -dSAFER -dBATCH \
		-dNOPAUSE -sDisplayHandle=0 \
		-sDEVICE=png16m -r200 -dTextAlphaBits=4 \
		-sOutputFile=${f%.*}.png -f $f
done


# HTML
echo "Generiere HTML-Dokument"
pandoc -t html -s -N -o $DOC_FOLDER/html/document.html $SOURCE
cp -r images $DOC_FOLDER/html/images

# HTML5
echo "Generiere HTML5-Dokument"
pandoc -t html5 -s -N -o $DOC_FOLDER/html5/document.html $SOURCE
cp -r images $DOC_FOLDER/html5/images

# TeX
echo "Generiere TeX-Dokument"
pandoc -t latex --template $DOC_FOLDER/latex/template.tex \
	-o $DOC_FOLDER/latex/document.tex $SOURCE

# OpenOffice odt
echo "Generiere OpenOffice/LibreOffice ODT-Dokument"
pandoc --table-of-contents -t odt -o $DOC_FOLDER/odt/document.odt $SOURCE

# docbook
echo "Generiere DocBook-Dokument"
pandoc -t docbook -o $DOC_FOLDER/docbook/document.xml $SOURCE

# epub
echo "Generiere EPub-Dokument"
pandoc -t epub -o $DOC_FOLDER/epub/document.epub $SOURCE

# Word .docx
echo "Generiere Microsoft Office DOCX-Dokument"
pandoc --table-of-contents -t docx -o $DOC_FOLDER/docx/document.docx $SOURCE

# plain text
echo "Generiere Plain-Text-Dokument"
pandoc --table-of-contents -t plain -o $DOC_FOLDER/plain/document.txt $SOURCE

# PDF
echo "Generiere PDF-Dokument"
pandoc --latex-engine=$PDFLATEX --table-of-contents --template $DOC_FOLDER/latex/template.tex -N \
	-o $DOC_FOLDER/pdf/document.pdf $SOURCE


cd $PWD
