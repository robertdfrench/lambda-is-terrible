view: slides.pdf
	open $<

slides.pdf: slides.tex
	texi2pdf --batch --clean $<

clean:
	rm -rf \
		*.aux \
		*.log \
		*.nav \
		*.out \
		*.pdf \
		*.toc \
		*.pdf \
		*.snm

