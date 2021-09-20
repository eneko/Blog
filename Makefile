
build:
	./scripts/build-and-package.sh IssueProcessorLambda

linuxtest:
	docker build -f LinuxTest.Dockerfile -t blog-lambda-test .
	docker run blog-lambda-test
