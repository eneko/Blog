FROM swift:5.4.1-amazonlinux2

WORKDIR /tmp

ADD Sources ./Sources
ADD Tests ./Tests
ADD Package.swift ./

CMD swift test -Xswiftc -Xfrontend -Xswiftc -enable-experimental-concurrency
