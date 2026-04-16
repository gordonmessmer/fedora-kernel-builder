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

**GitHub Container Registry (ghcr.io)**:
- Tagged images (`latest`, branch names) are kept indefinitely
- Untagged images are automatically deleted
- Git SHA-tagged images will accumulate over time

**Recommended retention policy**:
1. Go to your repository → Packages → Select the image
2. Click "Package settings"
3. Set up a retention policy to keep:
   - All tagged versions for 30 days
   - Only `latest` and branch tags permanently
   - This prevents unlimited growth from weekly SHA-tagged builds

**Manual cleanup** (if needed):
```bash
# List all versions
gh api /user/packages/container/PACKAGE-NAME/versions

# Delete old versions
gh api --method DELETE /user/packages/container/PACKAGE-NAME/versions/VERSION-ID
```

## License

This container image configuration is provided as-is for kernel development purposes.
