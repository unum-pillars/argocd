CLUSTER="do-{{ unum }}-unum"
LOCAL_PORT=6503
.PHONY: tfenv init remote install uninstall

tfenv:
	tfenv use 1.10.5

init: tfenv
	terraform init

remote:
	@echo "u/p u: admin p;"
	@kubectl --context=${CLUSTER} -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	@echo "\n"
	@open "http://localhost:${LOCAL_PORT}"
	kubectl --context=${CLUSTER} port-forward -n argocd service/argocd-server ${LOCAL_PORT}:http

install: init
	terraform apply

uninstall: init
	terraform destroy
