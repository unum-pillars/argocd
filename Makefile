VERSION?=$(shell cat VERSION)
ARGOCD_PORT=6567

.PHONY: crd install uninstall uncrd tag untag

crd:
	kubectl create -f crd.yaml

install:
	kubectl create namespace argocd
	kubectl apply -n argocd -f resources.yaml

local:
	@echo "u/p u: admin p;"
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	@echo "\n"
	@open "http://localhost:${ARGOCD_PORT}"
	kubectl port-forward -n argocd service/argocd-server ${ARGOCD_PORT}:http

uninstall:
	kubectl delete -n argocd -f resources.yaml
	kubectl delete namespace argocd

uncrd:
	kubectl delete -f crd.yaml

tag:
	-git tag -a $(VERSION) -m "Version $(VERSION)"
	git push origin --tags

untag:
	-git tag -d $(VERSION)
	git push origin ":refs/tags/$(VERSION)"
