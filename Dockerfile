FROM mongodb/mongodb-atlas-local

ARG CODE_RELEASE

LABEL maintainer="mmarcon"

USER root
RUN yum install -y \
  git \
  vim

RUN useradd -ms /bin/bash code && \
  mkdir -p /home/code/workspace && \
  chown -R code:code /home/code

RUN mkdir -p /code-server && \
  CODE_RELEASE=${CODE_RELEASE:-$(curl -s https://api.github.com/repos/coder/code-server/releases/latest | grep -Po '"tag_name":\s*"\K[^"]+')} && \
  curl -L "https://github.com/coder/code-server/releases/download/${CODE_RELEASE}/code-server-${CODE_RELEASE#v}-linux-amd64.tar.gz" -o /tmp/code-server.tar.gz && \
  tar -xzf /tmp/code-server.tar.gz -C /code-server --strip-components=1

USER code
RUN /code-server/bin/code-server --install-extension "mongodb.mongodb-vscode"

USER root
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD [ "/startup.sh" ]