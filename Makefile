
build:
	./scripts/build-and-package.sh IssueProcessorLambda

linuxtest:
	docker build -f LinuxTest.Dockerfile -t linuxtest .
	docker run linuxtest

