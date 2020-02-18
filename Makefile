SHELL=bash

view: slides.pdf
	open $<

slides.pdf: slides.tex
	texi2pdf --batch --clean $<

cgi_benchmark: clean
ifndef REQUESTS
	$(error "set $$REQUESTS=1024, to simulate 1024 requests")
endif
	time -p ./cgi_benchmark_wrapper.sh $(REQUESTS) > /dev/null

cgi_benchmark_concurrent:
ifndef CONCURRENCY
	$(error "set $$CONCURRENCY=2, for 2 cpus")
endif
ifndef REQUESTS
	$(error "set $$REQUESTS=1024, to simulate 1024 requests")
endif
	@echo -n "Requests per second: "
	@for i in `seq 1 $(CONCURRENCY)`; do
		($(MAKE) cgi_benchmark REQUESTS=$(REQUESTS) &);
	done 2>&1 \
		| awk '/real/ { print $$2 }' \
		| sort -g \
		| tail -n1 \
		| sed 's,^,$(REQUESTS)*$(CONCURRENCY)/,' \
		| bc

wsgi_benchmark:
ifndef CONCURRENCY
	$(error "set $$CONCURRENCY=2, for 2 cpus")
endif
ifndef REQUESTS
	$(error "set $$REQUESTS=1024, to simulate 1024 requests")
endif
	ab -c $(CONCURRENCY) -n $(REQUESTS) -m GET "http://127.0.0.1:8000/"

deploy_lambda: .terraform/init
	terraform apply -auto-approve

.terraform/init:
	terraform init
	@touch $@

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
