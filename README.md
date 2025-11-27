Azure Home Lab Infrastructure

This repository contains the infrastructure-as-code for my personal Azure-based homelab, built with Terraform. The goal of this project is to create a realistic, cloud-hosted environment where I can experiment with modern infrastructure patterns, automation, and platform engineering concepts, and then grow it over time as my skills and interests evolve.  ￼

Objectives

This homelab is designed to help me:
	•	Practice real-world Azure infrastructure design in a safe, low-risk environment.
	•	Experiment with Terraform: modules, state management, variables, and reusable patterns.
	•	Automate end-to-end environment provisioning, from core networking to workloads.
	•	Test DevOps & platform ideas, such as:
	•	Infrastructure CI/CD with GitHub Actions.
	•	Environment promotion patterns (dev / playground).
	•	Repeatable, idempotent deployments.

Although this is a personal learning project, the structure is intentionally close to what you’d expect in a professional environment, so parts of it can be reused in real projects.

What this repository does

At a high level, this repository defines the infrastructure layer of the homelab, which is fully hosted in Microsoft Azure. Terraform configuration in this repo is responsible for:
	•	Defining Azure resources (e.g. resource groups and core infrastructure primitives).
	•	Centralizing configuration via variables (for locations, naming, sizing, environment flags, etc.).
	•	Exposing key outputs that can be consumed by:
	•	Application/cluster layers in other repos.
	•	Future modules (e.g. AKS, VM workloads, platform services).

Note: The current version of this README focuses on the intent, structure, and patterns of the repo rather than listing every individual resource. As the lab grows, the resource list can be expanded (e.g. vNETs, subnets, AKS, VNets, NSGs, Key Vault, Log Analytics, etc.).

Repository structure

The repo is structured to clearly separate root configuration, reusable modules, and automation:
	•	main.tf
The root Terraform configuration entrypoint. This is where the overall homelab infrastructure is wired together by:
	•	Calling one or more modules from the modules/ folder.
	•	Declaring any top-level resources that don’t (yet) belong in a dedicated module.
	•	Referencing input variables and producing outputs.
	•	variables.tf
Central definition of input variables for the deployment. Typical things you configure here include:
	•	Azure region(s)
	•	Resource naming conventions / prefixes
	•	Environment type (e.g. dev, lab, playground)
	•	Feature flags for enabling/disabling certain components
	•	providers.tf
Configures the Terraform providers, primarily:
	•	azurerm for Azure resources (with any necessary features/configuration).
	•	(Optionally) other providers in future (e.g. random, TLS, GitHub).
	•	outputs.tf
Exposes important values after a successful terraform apply, such as:
	•	Resource group names/IDs
	•	Network details
	•	Any values needed by higher layers (clusters, apps, pipelines).
	•	modules/
A collection of reusable, self-contained Terraform modules. Each module is intended to model a logical building block of the homelab, for example:
	•	Core networking (vNET + subnets)
	•	Shared services (Key Vault, Log Analytics, etc.)
	•	Future compute layers (AKS clusters, VMs, jump hosts, etc.)
The idea is that each module can be:
	•	Developed and tested independently.
	•	Reused across environments.
	•	Extended as the lab grows.
	•	.github/workflows/
GitHub Actions workflows (now or in the future) used to:
	•	Run terraform fmt / terraform validate on pull requests.
	•	Plan and optionally apply changes automatically on pushes to specific branches.
	•	Enforce basic CI/CD practices for infrastructure.
	•	.terraform.lock.hcl
Terraform dependency lock file, ensuring consistent provider versions across machines and runs.
	•	.gitignore
Standard Git ignore rules to avoid committing local state, .terraform/ directories, editor configs, etc.

Usage (high level)
	1.	Prerequisites
	•	Terraform installed locally.
	•	An Azure subscription with sufficient permissions.
	•	Azure CLI or environment variables configured for authentication.
