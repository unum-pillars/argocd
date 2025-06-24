CLUSTER="docker-desktop"
VERSION?=$(shell cat VERSION)
LOCAL_PORT=6535

.PHONY: crd install local uninstall uncrd tag untag

crd:
	kubectl --context=${CLUSTER} create -k crd/

install:
	kubectl --context=${CLUSTER} create namespace argocd
	kubectl --context=${CLUSTER} apply -n argocd -k resources/

local:
	@echo "u/p u: admin p;"
	@kubectl --context=${CLUSTER} -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
	@echo "\n"
	@open "http://localhost:${LOCAL_PORT}"
	kubectl --context=${CLUSTER} port-forward -n argocd service/argocd-server ${LOCAL_PORT}:http

uninstall:
	kubectl --context=${CLUSTER} delete -n argocd -k resources/
	kubectl --context=${CLUSTER} delete namespace argocd

uncrd:
	kubectl --context=${CLUSTER} delete -k crd/

tag:
	-git tag -a $(VERSION) -m "Version $(VERSION)"
	git push origin --tags

untag:
	-git tag -d $(VERSION)
	git push origin ":refs/tags/$(VERSION)"
