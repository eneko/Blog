FROM swift:amazonlinux2

WORKDIR /tmp

ADD Sources ./Sources
ADD Tests ./Tests
ADD Package.swift ./

CMD swift test --enable-test-discovery

