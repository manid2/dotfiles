#!/bin/bash

# Configuration
LINK_TARGET="$HOME/.local"
DRY_RUN=false

usage() {
    echo "Usage: $0 [--dry-run] {install|uninstall} [file.rpm|package_name]"
    echo "Options:"
    echo "  -n, --dry-run    Show what would be done without making changes"
    exit 1
}

# Parse optional dry-run flag
if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

# Ensure local directories exist (if not dry-running)
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$LINK_TARGET"/{bin,share,lib,lib64,man}
fi

install_rpm() {
    local rpm_file=$1
    if [[ ! -f "$rpm_file" ]]; then
        echo "Error: RPM file '$rpm_file' not found."
        exit 1
    fi

    local pkg_name=$(rpm -qp --queryformat '%{NAME}' "$rpm_file" 2>/dev/null || basename "$rpm_file" .rpm)
    local pkg_dir="$(pwd)/$pkg_name"

    if [ "$DRY_RUN" = true ]; then
        echo "--- DRY RUN: INSTALLATION ---"
        echo "Would create directory: $pkg_dir"
        echo "Would extract files from: $rpm_file"

        # Simulate extraction to get file list for link prediction
        # We list tar contents and filter for interesting paths
        rpm2archive "$rpm_file"
        tar -tf "${rpm_file}.tgz" | while read -r line; do
            # Standardize path by removing leading dots/slashes
            local clean_path=$(echo "$line" | sed 's|^[./]*||')

            # Check if file falls into a linkable category
            for dir in bin share lib lib64 man; do
                if [[ "$clean_path" =~ ^(usr/)?$dir/([^/]+)$ ]]; then
                    local filename="${BASH_REMATCH[2]}"
                    echo "Would link: $LINK_TARGET/$dir/$filename -> $pkg_dir/$clean_path"
                fi
            done
        done
        rm "${rpm_file}.tgz"
        echo "-----------------------------"
    else
        echo "Installing $pkg_name..."
        mkdir -p "$pkg_dir"
        rpm2archive "$rpm_file"
        tar -xzf "${rpm_file}.tgz" -C "$pkg_dir"
        rm "${rpm_file}.tgz"

        for dir in bin share lib lib64 man; do
            for search_path in "$pkg_dir/usr/$dir" "$pkg_dir/$dir"; do
                if [ -d "$search_path" ]; then
                    find "$search_path" -maxdepth 1 -mindepth 1 | while read -r source; do
                        ln -sf "$source" "$LINK_TARGET/$dir/"
                        echo "Linked: $(basename "$source")"
                    done
                fi
            done
        done
    fi
}

uninstall_rpm() {
    local pkg_name=$1
    local pkg_dir="$(pwd)/$pkg_name"

    if [ "$DRY_RUN" = true ]; then
        echo "--- DRY RUN: UNINSTALL ---"
        echo "Would remove directory: $pkg_dir"
        echo "Would find and remove broken links in: $LINK_TARGET"
        find "$LINK_TARGET" -xtype l | while read -r link; do
            echo "Would remove broken link: $link"
        done
        echo "--------------------------"
    else
        if [ -d "$pkg_dir" ]; then
            rm -rf "$pkg_dir"
            echo "Removed $pkg_dir"
        fi
        find "$LINK_TARGET" -xtype l -delete
        echo "Cleaned up broken symlinks."
    fi
}

case "$1" in
    install) install_rpm "$2" ;;
    uninstall) uninstall_rpm "$2" ;;
    *) usage ;;
esac
