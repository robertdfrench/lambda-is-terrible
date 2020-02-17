SHELL=bash

view: slides.pdf
	open $<

slides.pdf: slides.tex
	texi2pdf --batch --clean $<

cgi_benchmark: clean
ifndef ITERATIONS
	$(error "set $$ITERATIONS=1024, to simulate 1024 requests")
endif
	time -p ./cgi_benchmark_wrapper.sh $(ITERATIONS) > /dev/null

cgi_benchmark_concurrent:
ifndef NUM_TASKS
	$(error "set $$NUM_TASKS=2, for 2 cpus")
endif
ifndef ITERATIONS
	$(error "set $$ITERATIONS=1024, to simulate 1024 requests")
endif
	@echo -n "Requests per second: "
	@for i in `seq 1 $(NUM_TASKS)`; do ($(MAKE) cgi_benchmark ITERATIONS=$(ITERATIONS) &); done 2>&1 \
		| awk '/real/ { print $$2 }' \
		| sort -g \
		| tail -n1 \
		| sed 's,^,$(ITERATIONS)*$(NUM_TASKS)/,' \
		| bc

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
