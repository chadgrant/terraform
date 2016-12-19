FROM golang:1.7.3
WORKDIR /terraform/
VOLUME ["/terraform/plans"]
ENV TF_LOG=INFO
ENV TF_LOG_PATH=/terraform/plans/terraform.log

ENV TERRAFORM_VERSION=0.7.13
ENV TERRAFORM_SHA256SUM=5a4f762a194542d38406b9b92c722b57f7910344db084e24c9c43d7719f4aa18

RUN apt-get update && apt-get install wget ca-certificates unzip git bash curl \
    unzip zip netcat-openbsd mysql-client bash-completion python && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    curl -o awscli-bundle.zip https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm -r awscli-bundle.zip && \
    rm -rf awscli-bundle && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    go get -u github.com/aws/aws-sdk-go/ && \
    go get -u github.com/hashicorp/hcl && \
    go get -u github.com/hashicorp/terraform

RUN mkdir -p /go/src/github.com/chadgrant/ && \
    cd /go/src/github.com/chadgrant/ && \
    git clone https://github.com/chadgrant/terraform-helpers.git && \
    cd terraform-helpers && \
    cd crypt && go install && \
    cd ../plan && go install && \
    cd ../apply && go install && \
    cd ../tfvars && go install

COPY modules /terraform/modules/
