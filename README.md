# cyber-plumber

This repo contains Terraform to provision resources in DigitalOcean to follow along with [The Cyber Plumber's Handbook](https://github.com/opsdisk/the_cyber_plumbers_handbook).

## Setup

Create a `tf/secret.tfvars` file. Add the DigitalOcean PAT to this file:

```
do_token = "<token>"
```

This file is part of the `.gitignore`.

## Creating the playground

Run the following:

```
make apply
```

## Destroying the playground

Run the following:

```
make destroy
```

