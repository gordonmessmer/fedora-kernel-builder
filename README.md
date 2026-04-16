# Fedora Kernel Builder Container Image

A Fedora-based container image with all tools needed for Linux kernel development and building.

## What's Included

### Build Tools
- **RPM Build**: rpm-build, rpmdevtools, kernel-rpm-macros, spectool
- **Repository Management**: createrepo_c
- **Compilers**: gcc, gcc-c++, make
- **Build Essentials**: bc, bison, flex

### Kernel Development
- **Core Dependencies**: bindgen, elfutils-devel, glibc-static
- **Security**: openssl-devel
- **Scripting**: perl-devel, perl-generators, python3-devel
- **Debug Tools**: dwarves, net-tools

### Toolchains
- **Rust**: rust, rust-src, rustfmt (for modern kernel development)
- **Node.js**: nodejs (for build scripts and tooling)
- **Git**: git (version control)

## Usage

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/YOUR-ORG/fedora-kernel-builder:latest
```

### Run Interactively

```bash
docker run -it --rm -v $(pwd):/workspace ghcr.io/YOUR-ORG/fedora-kernel-builder:latest
```

### Use in Forgejo Actions

```yaml
jobs:
  build-kernel:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/YOUR-ORG/fedora-kernel-builder:latest
    steps:
      - uses: actions/checkout@v4
      - name: Build kernel
        run: |
          make -C /path/to/kernel defconfig
          make -C /path/to/kernel -j$(nproc)
```

## Building Locally

```bash
docker build -t fedora-kernel-builder .
# or with podman
podman build -t fedora-kernel-builder .
```

## Automated Builds

This repository includes a GitHub Actions workflow that automatically builds and pushes the image to GitHub Container Registry when:
- Changes are pushed to the `Containerfile`
- Changes are pushed to the workflow file
- **Every Monday at 2:00 AM UTC** (to pick up Fedora package updates)
- Manually triggered via workflow_dispatch

Images are tagged with:
- `latest` (for main branch)
- Branch name (for all branches)
- Git SHA (for all commits)

### Image Retention

**Automatic cleanup** is configured in the workflow using [snok/container-retention-policy](https://github.com/snok/container-retention-policy):
- SHA-tagged images older than 30 days are automatically deleted
- At least 3 recent images are always kept
- `latest` and branch-name tags are preserved (no hyphen in tag)
- Cleanup runs every time the workflow executes

**Storage usage**:
- With weekly builds, you'll have ~4-5 SHA-tagged images at any time
- Plus `latest` and any branch tags (permanent)
- Total: ~5-10 image versions depending on activity

## License

This container image configuration is provided as-is for kernel development purposes.
