FROM registry.fedoraproject.org/fedora:latest

LABEL maintainer="Forgejo Code Signing Infrastructure"
LABEL description="Fedora-based kernel build environment with Node.js"

# Update system and install packages
RUN dnf update -y && \
    dnf install -y \
    # actions/forgejo-release tools
    jq \
    which \
    # RPM build tools
    rpm-build \
    rpmdevtools \
    kernel-rpm-macros \
    spectool \
    fedpkg \
    createrepo_c \
    # Compilers and build essentials
    pesign \
    gcc \
    gcc-c++ \
    make \
    bc \
    bison \
    flex \
    # Kernel build dependencies
    bindgen \
    elfutils-devel \
    glibc-static \
    openssl-devel \
    perl-devel \
    perl-generators \
    python3-devel \
    dwarves \
    gettext-envsubst \
    # Rust toolchain
    rust \
    rust-src \
    rustfmt \
    # Development utilities
    net-tools \
    git \
    nodejs \
    && dnf clean all

# Set up working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
