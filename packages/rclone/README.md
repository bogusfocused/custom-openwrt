This package installs [rclone](https://rclone.org) as a service on openwrt. `Rclonex` supports all [RClone options](https://rclone.org/docs/#options) and passes them exactly as provided.  See [configuration](#configuration) for details.

`Rclonex` supports on ubus all [Rclone rc commands](https://rclone.org/rc/#supported-commands) RClone utils adds new custom options that are suited to openwrt for ease of configuration but gets overridden by RClone options. Complete UBus and UCI support. Creates a new RClone service. You can edit the configuration using rclone web gui, uci or uploading a file. All of them gets synced.