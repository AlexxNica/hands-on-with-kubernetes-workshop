KISMATIC_VERSION=1.2.1

get-dependencies:
	wget --no-check-certificate -O - https://github.com/apprenda/kismatic/releases/download/v$(KISMATIC_VERSION)/kismatic-v$(KISMATIC_VERSION)-linux-amd64.tar.gz | tar -zx
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

plan:
	cd terraform && terraform plan

apply:
	cd terraform && time terraform apply

destroy:
	cd terraform && terraform destroy --force
	rm -rf ansible cfssl generated runs kismatic kubeconfig provision

provision-cluster:
	chmod 600 ssh/cluster.pem
	time ./kismatic install apply -f kismatic-cluster.yaml
	cp generated/kubeconfig .