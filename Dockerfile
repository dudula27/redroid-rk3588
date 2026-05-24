# ==============================================================================
# 阶段 1: 工具偷渡阶段 (获取纯静态编译、无外部依赖的 busybox)
# ==============================================================================
FROM busybox:stable-musl AS tool

# ==============================================================================
# 阶段 2: 终极精简阶段 (本地高效闭环)
# ==============================================================================
FROM cnflysky/redroid-rk3588:lineage-20

# 1. 强制登入 root
USER 0

# 2. 💡 将静态 busybox 塞进临时目录
COPY --from=tool /bin/busybox /tmp/busybox

# 3. 💡 显式指定使用这个不受安卓 Bionic 库制约的「静态 Shell」接管编译期
SHELL ["/tmp/busybox", "sh", "-c"]

# 4. ⚡ 单层 RUN 究极超度（从日志直接还原的静态完全体）
# 彻底告别外部清单与脚本依赖，单点闭环，执行后连同 busybox 一并自我销毁
RUN /tmp/busybox rm -rf \
    "/product/etc/default-permissions/default-permissions-google.xml" \
    "/product/etc/default-permissions/default-permissions-mtg.xml" \
    "/product/etc/init/gapps.rc" \
    "/product/etc/permissions/com.google.android.dialer.support.xml" \
    "/product/etc/permissions/privapp-permissions-google-product.xml" \
    "/product/etc/security/fsverity/gms_fsverity_cert.der" \
    "/product/etc/sysconfig/d2d_cable_migration_feature.xml" \
    "/product/etc/sysconfig/google-hiddenapi-package-allowlist.xml" \
    "/product/etc/sysconfig/google.xml" \
    "/product/etc/sysconfig/google_build.xml" \
    "/product/framework/com.google.android.dialer.support.jar" \
    "/product/overlay/GmsOverlay.apk" \
    "/product/overlay/GmsSettingsProviderOverlay.apk" \
    "/product/priv-app/GmsCore" \
    "/product/priv-app/GoogleRestore" \
    "/product/priv-app/Phonesky" \
    "/system/product/etc/default-permissions/default-permissions-google.xml" \
    "/system/product/etc/default-permissions/default-permissions-mtg.xml" \
    "/system/product/etc/init/gapps.rc" \
    "/system/product/etc/permissions/com.google.android.dialer.support.xml" \
    "/system/product/etc/permissions/privapp-permissions-google-product.xml" \
    "/system/product/etc/security/fsverity/gms_fsverity_cert.der" \
    "/system/product/etc/sysconfig/d2d_cable_migration_feature.xml" \
    "/system/product/etc/sysconfig/google-hiddenapi-package-allowlist.xml" \
    "/system/product/etc/sysconfig/google.xml" \
    "/system/product/etc/sysconfig/google_build.xml" \
    "/system/product/framework/com.google.android.dialer.support.jar" \
    "/system/product/overlay/GmsOverlay.apk" \
    "/system/product/overlay/GmsSettingsProviderOverlay.apk" \
    "/system/product/priv-app/GmsCore" \
    "/system/product/priv-app/GoogleRestore" \
    "/system/product/priv-app/Phonesky" \
    "/system/system_ext/etc/permissions/privapp-permissions-google-system-ext.xml" \
    "/system/system_ext/priv-app/GoogleServicesFramework" \
    "/system_ext/etc/permissions/privapp-permissions-google-system-ext.xml" \
    "/system_ext/priv-app/GoogleServicesFramework" && \
    /tmp/busybox rm -f /tmp/busybox