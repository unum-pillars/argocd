VERSION?=$(shell cat VERSION)
ARGOCD_PORT=6567

.PHONY: crd install uninstall uncrd tag untag

crd:
	kubectl create -k crd/

install:
	kubectl create namespace argocd
	kubectl apply -n argocd -k resources/

local:
	@echo "u/p u: admin p;"
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	@echo "\n"
	@open "http://localhost:${ARGOCD_PORT}"
	kubectl port-forward -n argocd service/argocd-server ${ARGOCD_PORT}:http

uninstall:
	kubectl delete -n argocd -k resources/
	kubectl delete namespace argocd

uncrd:
	kubectl delete -k crd/

tag:
	-git tag -a $(VERSION) -m "Version $(VERSION)"
	git push origin --tags

untag:
	-git tag -d $(VERSION)
	git push origin ":refs/tags/$(VERSION)"
