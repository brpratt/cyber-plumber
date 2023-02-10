.PHONY: fmt
fmt:
	terraform -chdir=tf fmt -recursive

.PHONY: plan
plan:
	terraform -chdir=tf plan -var-file="secret.tfvars"

.PHONY: apply
apply:
	terraform -chdir=tf apply -var-file="secret.tfvars"

.PHONY: destroy
destroy:
	terraform -chdir=tf destroy -var-file="secret.tfvars"
