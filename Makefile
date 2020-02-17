view: slides.pdf
	open $<

slides.pdf: slides.tex
	texi2pdf --batch --clean $<

cgi_benchmark: clean
	time ./cgi_benchmark_wrapper.sh 1024 > /dev/null

wsgi_benchmark:
	ab -m GET "http://127.0.0.1:8000/"

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
