#Disable Strict Aliasing Optimizations
CFLAGS_KERNEL += -fno-strict-aliasing

obj-y += mhi_main.o mhi_iface.o mhi_init.o mhi_isr.o mhi_mmio_ops.o mhi_ring_ops.o mhi_states.o mhi_sys.o \
mhi_uci.o msm_rmnet_mhi.o mhi_bhi.o mhi_pm.o mhi_ssr.o
obj-$(CONFIG_DEBUG_PKTLOG) += modem_pktlog.o
