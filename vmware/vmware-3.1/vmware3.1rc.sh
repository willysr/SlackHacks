#!/bin/bash
# -*- coding: UTF8 -*-

FOLDER=/tmp/$RANDOM$RANDDOM


mkdir $FOLDER

cd  $FOLDER
cp /usr/lib/vmware/modules/source/{vmnet.tar,vmnet.tar.old}
tar xvf /usr/lib/vmware/modules/source/vmnet.tar
patch -p0 << EOF
--- vmnet-only/compat_netdevice.h	2011-03-26 06:37:29.000000000 +0100
+++ vmnet-only/compat_netdevice.h	2011-08-10 08:17:57.000000000 +0200
@@ -47,6 +47,19 @@
 #   define net_device device
 #endif
 
+/* it looks like these have been removed from the kernel 3.1
+ * probably because the "transition" is considered complete.
+ * so to keep this source compatible we just redefine them like they were
+ * previously
+ */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 1, 0)
+#define HAVE_ALLOC_NETDEV		/* feature macro: alloc_xxxdev
+					   functions are available. */
+#define HAVE_FREE_NETDEV		/* free_netdev() */
+#define HAVE_NETDEV_PRIV		/* netdev_priv() */
+#define HAVE_NETIF_QUEUE
+#define HAVE_NET_DEVICE_OPS
+#endif
 
 /*
  * SET_MODULE_OWNER appeared sometime during 2.3.x. It was setting
EOF
tar cf /usr/lib/vmware/modules/source/vmnet.tar vmnet-only 
vmware-modconfig --console --install-all 
rm -rf  $FOLDER

