Azure Home Lab Infrastructure

This repository contains the infrastructure-as-code for my Azure-based personal homelab, built using Terraform.
The goal is to create a realistic, cloud-hosted environment where I can explore modern infrastructure patterns, platform engineering concepts, and automation workflows—while having the flexibility to grow the environment as my skills evolve.

Objectives

This homelab helps me:

Practice real-world Azure infrastructure design in a safe, low-risk environment.

Experiment with Terraform concepts such as modules, state management, variables, and reusable patterns.

Automate end-to-end provisioning, from core networking to workloads.

Test DevOps and platform engineering ideas:

CI/CD for infrastructure using GitHub Actions

Environment promotion patterns (e.g., dev, playground)

Repeatable, idempotent deployments

Although this is a personal learning project, the repository structure intentionally resembles professional IaC project patterns, making it suitable for reuse in real-world scenarios.

What This Repository Does

At a high level, this repository defines the infrastructure layer of the homelab, fully hosted in Microsoft Azure.

Terraform in this repo is responsible for:

Creating Azure resources (resource groups, networking, primitives, etc.)

Centralizing configuration using variables (regions, naming, sizing, environment flags)

Producing outputs that are consumed by:

Application or cluster layers in other repositories

Future modules (AKS, VM workloads, shared services, etc.)

Note:
The current README focuses on patterns, intent, and structure. As the lab grows (vNETs, NSGs, Key Vault, AKS, Log Analytics, etc.), a detailed resource list will be added.

Repository Structure

The repository separates root configuration, reusable modules, and automation:

Root Terraform Files

main.tf
Entry point of the Terraform configuration, responsible for:

Calling modules from the modules/ directory

Declaring any standalone resources

Referencing variables and exposing outputs

variables.tf
Central configuration for input variables such as:

Azure region

Naming conventions / prefixes

Environment type (dev, lab, playground)

Feature flags for optional components

providers.tf
Configures Terraform providers, primarily:

azurerm for Azure

Optional providers (e.g., random, tls, github) as the lab expands

outputs.tf
Exposes key values after terraform apply, such as:

Resource group IDs

Networking information

Values needed by upper layers (clusters, pipelines, etc.)

Modules

modules/ contains reusable, self-contained Terraform modules.
Each module represents a logical building block, for example:

Core networking (vNET + subnets)

Shared services (Key Vault, Log Analytics, etc.)

Compute layers (AKS, VM workloads, jump host)

Each module is designed to be:

Independently developed and tested

Reusable across environments

Extensible as the homelab expands

Automation

.github/workflows/
Contains GitHub Actions workflows used to:

Run terraform fmt and terraform validate on PRs

Execute plan/apply pipelines for IaC changes

Enforce infrastructure CI/CD best practices
