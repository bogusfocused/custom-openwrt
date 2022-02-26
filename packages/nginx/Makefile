#
# Copyright (C) 2012-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nginx
PKG_UPSTREAM_VERSION:=1.21.6
PKG_VERSION:=$(PKG_UPSTREAM_VERSION)
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=nginx-$(PKG_UPSTREAM_VERSION).tar.gz
PKG_SOURCE_URL:=https://nginx.org/download/
PKG_HASH:=66dc7081488811e9f925719e34d1b4504c2801c81dee2920e5452a86b11405ae

PKG_MAINTAINER:=Rohit Lodha <bogusfocused@gmail.com>

PKG_LICENSE:=2-clause BSD-like license
PKG_CPE_ID:=cpe:/a:nginx:nginx

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:= openssl pcre zlib libgd


NGINX_PROVIDERS:=nginx-default nginx-default-ssl nginx-full nginx-reverse-proxy 



NGX_CONFIGURE_ARGS:=

ifeq ($(BUILD_VARIANT),default)
NGX_MAIL:=m
NGX_STREAM:=m
NGX_STREAM_REALIP:=y
endif

ifeq ($(BUILD_VARIANT),ssl)
NGX_HTTP_SSL:=y
NGX_HTTP_V2:=y
endif

ifeq ($(BUILD_VARIANT),full)
NGX_HTTP_SSL:=y
NGX_HTTP_V2:=y
NGX_HTTP_REALIP:=y
NGX_HTTP_DAV:=y
NGX_HTTP_FLV:=y
NGX_HTTP_AUTH_REQUEST:=y
NGX_MAIL:=m
NGX_MAIL_SSL:=y
NGX_STREAM:=m
NGX_STREAM_SSL:=y
NGX_STREAM_REALIP:=y
NGX_HTTP_IMAGE_FILTER:=m
endif


ifeq ($(NGX_HTTP),n)
	NGX_CONFIGURE_ARGS += --without-http
else
	ifeq ($(NGX_HTTP_SSL), y)
		NGX_CONFIGURE_ARGS += --with-http_ssl_module
	endif
	ifeq ($(NGX_HTTP_V2),y)
		NGX_CONFIGURE_ARGS += --with-http_v2_module
	endif
	ifeq ($(NGX_HTTP_REALIP),y)
		NGX_CONFIGURE_ARGS += --with-http_realip_module
	endif
	ifeq ($(NGX_HTTP_ADDITION),y)
		NGX_CONFIGURE_ARGS += --with-http_addition_module
	endif
	ifeq ($(NGX_HTTP_XSLT),y)
		NGX_CONFIGURE_ARGS += --with-http_xslt_module
	endif
	ifeq ($(NGX_HTTP_IMAGE_FILTER),y)
		NGX_CONFIGURE_ARGS += --with-http_image_filter_module
	endif
	ifeq ($(NGX_HTTP_GEOIP),y)
		NGX_CONFIGURE_ARGS += --with-http_geoip_module
	endif
	ifeq ($(NGX_HTTP_SUB),y)
		NGX_CONFIGURE_ARGS += --with-http_sub_module
	endif
	ifeq ($(NGX_HTTP_DAV),y)
		NGX_CONFIGURE_ARGS += --with-http_dav_module
	endif
	ifeq ($(NGX_HTTP_FLV),y)
		NGX_CONFIGURE_ARGS += --with-http_flv_module
	endif
	ifeq ($(NGX_HTTP_MP4),y)
		NGX_CONFIGURE_ARGS += --with-http_mp4_module
	endif
	ifeq ($(NGX_HTTP_GUNZIP),y)
		NGX_CONFIGURE_ARGS += --with-http_gunzip_module
	endif
	ifeq ($(NGX_HTTP_GZIP_STATIC),y)
		NGX_CONFIGURE_ARGS += --with-http_gzip_static_module
	endif
	ifeq ($(NGX_HTTP_AUTH_REQUEST),y)
		NGX_CONFIGURE_ARGS += --with-http_auth_request_module
	endif
	ifeq ($(NGX_HTTP_RANDOM_INDEX),y)
		NGX_CONFIGURE_ARGS += --with-http_random_index_module
	endif
	ifeq ($(NGX_HTTP_SECURE_LINK),y)
		NGX_CONFIGURE_ARGS += --with-http_secure_link_module
	endif
	ifeq ($(NGX_HTTP_DEGRADATION),y)
		NGX_CONFIGURE_ARGS += --with-http_degradation_module
	endif
	ifeq ($(NGX_HTTP_SLICE),y)
		NGX_CONFIGURE_ARGS += --with-http_slice_module
	endif
	ifeq ($(NGX_HTTP_STUB_STATUS),y)
		NGX_CONFIGURE_ARGS += --with-http_stub_status_module
	endif
	ifeq ($(NGX_HTTP_CHARSET),n)
		NGX_CONFIGURE_ARGS += --without-http_charset_module
	endif
	ifeq ($(NGX_HTTP_GZIP),n)
		NGX_CONFIGURE_ARGS += --without-http_gzip_module
	endif
	ifeq ($(NGX_HTTP_SSI),n)
		NGX_CONFIGURE_ARGS += --without-http_ssi_module
	endif
	ifeq ($(NGX_HTTP_USERID),n)
		NGX_CONFIGURE_ARGS += --without-http_userid_module
	endif
	ifeq ($(NGX_HTTP_ACCESS),n)
		NGX_CONFIGURE_ARGS += --without-http_access_module
	endif
	ifeq ($(NGX_HTTP_AUTH_BASIC),n)
		NGX_CONFIGURE_ARGS += --without-http_auth_basic_module
	endif
	ifeq ($(NGX_HTTP_MIRROR),n)
		NGX_CONFIGURE_ARGS += --without-http_mirror_module
	endif
	ifeq ($(NGX_HTTP_AUTOINDEX),n)
		NGX_CONFIGURE_ARGS += --without-http_autoindex_module
	endif
	ifeq ($(NGX_HTTP_GEO),n)
		NGX_CONFIGURE_ARGS += --without-http_geo_module
	endif
	ifeq ($(NGX_HTTP_MAP),n)
		NGX_CONFIGURE_ARGS += --without-http_map_module
	endif
	ifeq ($(NGX_HTTP_SPLIT_CLIENTS),n)
		NGX_CONFIGURE_ARGS += --without-http_split_clients_module
	endif
	ifeq ($(NGX_HTTP_REFERER),n)
		NGX_CONFIGURE_ARGS += --without-http_referer_module
	endif
	ifeq ($(NGX_HTTP_REWRITE),n)
		NGX_CONFIGURE_ARGS += --without-http_rewrite_module
	endif
	ifeq ($(NGX_HTTP_PROXY),n)
		NGX_CONFIGURE_ARGS += --without-http_proxy_module
	endif
	ifeq ($(NGX_HTTP_FASTCGI),n)
		NGX_CONFIGURE_ARGS += --without-http_fastcgi_module
	endif
	ifeq ($(NGX_HTTP_UWSGI),n)
		NGX_CONFIGURE_ARGS += --without-http_uwsgi_module
	endif
	ifeq ($(NGX_HTTP_SCGI),n)
		NGX_CONFIGURE_ARGS += --without-http_scgi_module
	endif
	ifeq ($(NGX_HTTP_GRPC),n)
		NGX_CONFIGURE_ARGS += --without-http_grpc_module
	endif
	ifeq ($(NGX_HTTP_MEMCACHED),n)
		NGX_CONFIGURE_ARGS += --without-http_memcached_module
	endif
	ifeq ($(NGX_HTTP_LIMIT_CONN),n)
		NGX_CONFIGURE_ARGS += --without-http_limit_conn_module
	endif
	ifeq ($(NGX_HTTP_LIMIT_REQ),n)
		NGX_CONFIGURE_ARGS += --without-http_limit_req_module
	endif
	ifeq ($(NGX_HTTP_EMPTY_GIF),n)
		NGX_CONFIGURE_ARGS += --without-http_empty_gif_module
	endif
	ifeq ($(NGX_HTTP_BROWSER),n)
		NGX_CONFIGURE_ARGS += --without-http_browser_module
	endif
	ifeq ($(NGX_HTTP_UPSTREAM_HASH),n)
		NGX_CONFIGURE_ARGS += --without-http_upstream_hash_module
	endif
	ifeq ($(NGX_HTTP_UPSTREAM_IP_HASH),n)
		NGX_CONFIGURE_ARGS += --without-http_upstream_ip_hash_module
	endif
	ifeq ($(NGX_HTTP_UPSTREAM_LEAST_CONN),n)
		NGX_CONFIGURE_ARGS += --without-http_upstream_least_conn_module
	endif
	ifeq ($(NGX_HTTP_UPSTREAM_RANDOM),n)
		NGX_CONFIGURE_ARGS += --without-http_upstream_random_module
	endif
	ifeq ($(NGX_HTTP_UPSTREAM_KEEPALIVE),n)
		NGX_CONFIGURE_ARGS += --without-http_upstream_keepalive_module
	endif
	ifeq ($(NGX_HTTP_UPSTREAM_ZONE),n)
		NGX_CONFIGURE_ARGS += --without-http_upstream_zone_module
	endif
	ifeq ($(NGX_HTTP_PERL),y)
		NGX_CONFIGURE_ARGS += --with-http_perl_module
	endif
	ifeq ($(NGX_HTTP_IMAGE_FILTER),m)
		NGX_CONFIGURE_ARGS += --with-http_image_filter_module=dynamic
	endif
	ifeq ($(NGX_HTTP_XSLT),m)
		NGX_CONFIGURE_ARGS += --with-http_xslt_module=dynamic
	endif
	ifeq ($(NGX_HTTP_GEOIP),m)
		NGX_CONFIGURE_ARGS += --with-http_geoip_module=dynamic
	endif
	ifeq ($(NGX_HTTP_PERL),m)
		NGX_CONFIGURE_ARGS += --with-http_perl_module=dynamic
	endif
endif
ifneq ($(NGX_MAIL),n)
	ifeq ($(NGX_MAIL),y)
		NGX_CONFIGURE_ARGS += --with-mail
	endif
	ifeq ($(NGX_MAIL),m)
		NGX_CONFIGURE_ARGS += --with-mail=dynamic
	endif
	ifeq ($(NGX_MAIL_SSL),y)
		NGX_CONFIGURE_ARGS += --with-mail_ssl_module
	endif
	ifeq ($(NGX_MAIL_IMAP),n)
		NGX_CONFIGURE_ARGS += --without-mail_imap_module
	endif
	ifeq ($(NGX_MAIL_SMTP),n)
		NGX_CONFIGURE_ARGS += --without-mail_smtp_module
	endif
	ifeq ($(NGX_MAIL_POP3),n)
		NGX_CONFIGURE_ARGS += --without-mail_pop3_module
	endif
endif

ifneq ($(NGX_STREAM),n)
	ifeq ($(NGX_STREAM),y)
		NGX_CONFIGURE_ARGS += --with-stream
	endif
	ifeq ($(NGX_STREAM_SSL_PREREAD),y)
		NGX_CONFIGURE_ARGS += --with-stream_ssl_preread_module
		NGX_STREAM_SSL:=y
	endif
	ifeq ($(NGX_STREAM_SSL),y)
		NGX_CONFIGURE_ARGS += --with-stream_ssl_module
	endif
	ifeq ($(NGX_STREAM_REALIP),y)
		NGX_CONFIGURE_ARGS += --with-stream_realip_module
	endif
	ifeq ($(NGX_STREAM_GEOIP),y)
		NGX_CONFIGURE_ARGS += --with-stream_geoip_module
	endif
	ifeq ($(NGX_STREAM_LIMIT_CONN),n)
		NGX_CONFIGURE_ARGS += --without-stream_limit_conn_module
	endif
	ifeq ($(NGX_STREAM_ACCESS),n)
		NGX_CONFIGURE_ARGS += --without-stream_access_module
	endif
	ifeq ($(NGX_STREAM_GEO),n)
		NGX_CONFIGURE_ARGS += --without-stream_geo_module
	endif
	ifeq ($(NGX_STREAM_MAP),n)
		NGX_CONFIGURE_ARGS += --without-stream_map_module
	endif
	ifeq ($(NGX_STREAM_SPLIT_CLIENTS),n)
		NGX_CONFIGURE_ARGS += --without-stream_split_clients_module
	endif
	ifeq ($(NGX_STREAM_RETURN),n)
		NGX_CONFIGURE_ARGS += --without-stream_return_module
	endif
	ifeq ($(NGX_STREAM_SET),n)
		NGX_CONFIGURE_ARGS += --without-stream_set_module
	endif
	ifeq ($(NGX_STREAM_UPSTREAM_HASH),n)
		NGX_CONFIGURE_ARGS += --without-stream_upstream_hash_module
	endif
	ifeq ($(NGX_STREAM_UPSTREAM_LEAST_CONN),n)
		NGX_CONFIGURE_ARGS += --without-stream_upstream_least_conn_module
	endif
	ifeq ($(NGX_STREAM_UPSTREAM_RANDOM),n)
		NGX_CONFIGURE_ARGS += --without-stream_upstream_random_module
	endif
	ifeq ($(NGX_STREAM_UPSTREAM_ZONE),n)
		NGX_CONFIGURE_ARGS += --without-stream_upstream_zone_module
	endif
	ifeq ($(NGX_STREAM_GEOIP),m)
		NGX_CONFIGURE_ARGS += --with-stream_geoip_module=dynamic
	endif
	ifeq ($(NGX_STREAM),m)
		NGX_CONFIGURE_ARGS += --with-stream=dynamic
	endif
endif

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/nginx/Default
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Web Servers/Proxies
	TITLE:=Nginx web server
	URL:=http://nginx.org/
	DEPENDS= +libpthread +libpcre
endef

define Package/nginx/description
 nginx is an HTTP and reverse proxy server, as well as a mail proxy server, \
 written by Igor Sysoev.
endef

define Package/nginx-default
	$(call Package/nginx/Default)
	TITLE += (Default options)
	VARIANT:=default
	PROVIDES:=nginx
	DEPENDS += +zlib
endef

define Package/nginx-default/description
$(call Package/nginx/description)

This variant is built using all default configuration.
endef

define Package/nginx-default-ssl
	$(call Package/nginx/Default)
	TITLE += (SSL)
	VARIANT:=ssl
	PROVIDES:=nginx
	DEPENDS += +libopenssl +zlib
endef

define Package/nginx-default-ssl/description
$(call Package/nginx/description)

This variant is with ssl support
endef

define Package/nginx-full
	$(call Package/nginx/Default)
	TITLE += (Full)
	VARIANT:=full
	PROVIDES:=nginx
	DEPENDS += +zlib +libopenssl
endef

define Package/nginx-full/description
$(call Package/nginx/description)

This variant is built using all inclusive configuration.
endef

define Package/nginx-module/Default
	$(call Package/nginx/Default)
	TITLE += (module)
	DEPENDS +=@$(subst $(space),||,$(foreach pkg,$(NGINX_PROVIDERS),PACKAGE_$(pkg)))
endef

define Package/nginx-mod-image_filter
	$(call Package/nginx-module/Default)
	TITLE += (Image filter)
	VARIANT:=full
	PROVIDES:=ngx_http_image_filter_module.so
	DEPENDS += +libgd
endef

define Package/nginx-mod-image_filter/description
$(call Package/nginx/description)

This is image filter  module
endef


define Package/nginx-mod-stream
	$(call Package/nginx-module/Default)
	TITLE += (Stream)
	VARIANT:=default
	PROVIDES:= ngx_stream_module.so
endef


define Package/nginx-mod-stream/description
$(call Package/nginx/description)

This is stream  module
endef


define Package/nginx-mod-mail
	$(call Package/nginx-module/Default)
	TITLE += (Mail)
	VARIANT:=default
	PROVIDES:= ngx_mail_module.so
endef


define Package/nginx-mod-mail/description
$(call Package/nginx/description)

This is mail  module
endef

define Package/nginx-mod-stream-ssl
	$(call Package/nginx-module/Default)
	TITLE += (Stream SSL)
	VARIANT:=full
	PROVIDES:= ngx_stream_module.so
endef

define Package/nginx-mod-stream-ssl/description
$(call Package/nginx/description)

This is stream  SSL module
endef

define Package/nginx-mod-mail-ssl
	$(call Package/nginx-module/Default)
	TITLE += (Mail SSL)
	VARIANT:=full
	PROVIDES:= ngx_mail_module.so
endef


define Package/nginx-mod-mail-ssl/description
$(call Package/nginx/description)

This is mail  SSL module
endef

EXTRA_CFLAGS += -fvisibility=hidden -ffunction-sections -fdata-sections
EXTRA_LDFLAGS += -Wl,--gc-sections 

CONFIGURE_VARS += CONFIG_BIG_ENDIAN=$(CONFIG_BIG_ENDIAN)

NGX_CONFIGURE_ARGS += \
	--crossbuild=Linux::$(ARCH) \
	--prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--modules-path=/usr/lib/nginx/modules \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--http-client-body-temp-path=/var/cache/nginx/client_temp \
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
	--with-compat \
	--with-file-aio \
	--with-threads \
	--with-cc="$(TARGET_CC)" \
	--with-cc-opt="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS)" \
	--with-ld-opt="$(TARGET_LDFLAGS)" \
	--without-http_upstream_zone_module


extra_files += mime.types
ifeq ($(NGX_HTTP_CHARSET),y)
		extra_files += koi-utf koi-win win-utf
	endif
ifeq ($(NGX_HTTP_FASTCGI),y)
		extra_files += fastcgi_params
	endif
ifeq ($(NGX_HTTP_UWSGI),y)
		extra_files += uwsgi_params
	endif
ifeq ($(NGX_HTTP_SCGI),y)
		extra_files += scgi_params
	endif


define Package/nginx/conffiles
/etc/nginx/nginx.conf
endef		

define Build/Configure
	$(call Build/Configure/Default, $(NGX_CONFIGURE_ARGS), $(2),$(3))
endef
	 
define Package/nginx/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/nginx $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/nginx.init $(1)/etc/init.d/nginx
	$(INSTALL_DIR) $(1)/etc/nginx
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/nginx/nginx.conf $(1)/etc/nginx/nginx.conf
	$(INSTALL_DATA) $(addprefix $(PKG_INSTALL_DIR)/etc/nginx/,$(extra_files)) $(1)/etc/nginx/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/html/* $(1)/etc/nginx/
endef

define Package/nginx-mod-image_filter/install
	$(INSTALL_DIR) $(1)/usr/lib/nginx/modules
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/objs/ngx_http_image_filter_module.so $(1)/usr/lib/nginx/modules
endef

define Package/nginx-mod-stream/install
	$(INSTALL_DIR) $(1)/usr/lib/nginx/modules
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/objs/ngx_stream_module.so $(1)/usr/lib/nginx/modules
endef

define Package/nginx-mod-stream-ssl/install
	$(INSTALL_DIR) $(1)/usr/lib/nginx/modules
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/objs/ngx_stream_module.so $(1)/usr/lib/nginx/modules
endef

define Package/nginx-mod-mail/install
	$(INSTALL_DIR) $(1)/usr/lib/nginx/modules
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/objs/ngx_mail_module.so $(1)/usr/lib/nginx/modules
endef

define Package/nginx-mod-mail-ssl/install
	$(INSTALL_DIR) $(1)/usr/lib/nginx/modules
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/objs/ngx_mail_module.so $(1)/usr/lib/nginx/modules
endef

Package/nginx-default/conffiles = $(Package/nginx/conffiles)
Package/nginx-default-ssl/conffiles = $(Package/nginx/conffiles)
Package/nginx-full/conffiles = $(Package/nginx/conffiles)

Package/nginx-default/install = $(Package/nginx/install)
Package/nginx-default-ssl/install = $(Package/nginx/install)
Package/nginx-full/install = $(Package/nginx/install)

$(eval $(call BuildPackage,nginx-default))
$(eval $(call BuildPackage,nginx-default-ssl))
$(eval $(call BuildPackage,nginx-full))
$(eval $(call BuildPackage,nginx-mod-image_filter))
$(eval $(call BuildPackage,nginx-mod-stream))
$(eval $(call BuildPackage,nginx-mod-mail))
$(eval $(call BuildPackage,nginx-mod-stream-ssl))
$(eval $(call BuildPackage,nginx-mod-mail-ssl))


