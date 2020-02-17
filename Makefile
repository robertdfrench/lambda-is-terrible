view: slides.pdf
	open $<

slides.pdf: slides.tex
	texi2pdf --batch --clean $<

cgi_benchmark: clean
	time ./cgi_benchmark_wrapper.sh 1024 > /dev/null

clean:
	rm -rf \
		*.sqlite3 \
		*.aux \
		*.log \
		*.nav \
		*.out \
		*.pdf \
		*.toc \
		*.pdf \
		*.snm
