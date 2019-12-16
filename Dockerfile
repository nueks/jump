FROM alpine:3.10

RUN apk update && \
	apk add --no-cache openssh ca-certificates && \
	update-ca-certificates && \
	rm -rf /var/cache/apk/*

RUN sed -i -e 's/AllowTcpForwarding no/AllowTcpForwarding yes/' \
	-e 's/#AllowAgentForwarding yes/AllowAgentforwarding yes/' \
	-e 's/X11Forwarding no/X11Forwarding yes/' \
	-e 's/#X11UseLocalhost yes/X11UseLocalhost no/' \
	-e 's/#LogLevel INFO/LogLevel INFO/' \
	/etc/ssh/sshd_config

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
	ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
	ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
	ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

RUN adduser -D -s /bin/sh nueks && \
	passwd -d nueks && \
	cd /home/nueks && \
	mkdir .ssh && \
	cd .ssh

ADD authorized_keys /home/nueks/.ssh

RUN chown -R nueks:nueks /home/nueks
RUN chmod 755 /home/nueks
RUN chmod 755 /home/nueks/.ssh

CMD ["/usr/sbin/sshd", "-D", "-e"]
