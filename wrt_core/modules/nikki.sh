#!/usr/bin/env bash

update_nikki() {
    # 移除 feeds 中现有的冲突包
    local remove_pkgs=(
        "luci-app-mihomo" "luci-app-nikki" "mihomo" "nikki"
    )

    for pkg in "${remove_pkgs[@]}"; do
        if [[ -d "$BUILD_DIR/feeds/luci/applications/$pkg" ]]; then
            \rm -rf "$BUILD_DIR/feeds/luci/applications/$pkg"
        fi
        if [[ -d "$BUILD_DIR/feeds/packages/net/$pkg" ]]; then
            \rm -rf "$BUILD_DIR/feeds/packages/net/$pkg"
        fi
        if [[ -d "$BUILD_DIR/feeds/small8/$pkg" ]]; then
            \rm -rf "$BUILD_DIR/feeds/small8/$pkg"
        fi
    done

    # 从远程仓库克隆
    local target_dir="$BUILD_DIR/package/nikki"
    local repo_url="https://github.com/nikkinikki-org/OpenWrt-nikki.git"

    echo "正在添加/更新 nikki..."
    rm -rf "$target_dir" 2>/dev/null

    if ! git clone --depth 1 -b main "$repo_url" "$target_dir"; then
        echo "错误：从 $repo_url 克隆 nikki 仓库失败" >&2
        exit 1
    fi
}
