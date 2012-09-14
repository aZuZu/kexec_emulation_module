ifeq ($(KERNEL_FOLDER),)
KERNEL_FOLDER=/home/azuzu/aZuZu_Google/Kernels/nobodyAtall-nAa-kernel-cd09061/
else
KERNLEL_FOLDER=$(KERNEL_FOLDER)
endif
ifeq ($(cpu), msm7k)
EXTRA_CFLAGS += -DCONFIG_KEXEC -DCONFIG_ARM -Wall -march=armv6k -mtune=strongarm -mfpu=vfp
else ifeq ($(cpu),qsd8k)
EXTRA_CFLAGS += -DCONFIG_KEXEC -DCONFIG_ARM -DCONFIG_ARCH_QSD8X50 -Wall -march=armv7-a -mfloat-abi=softfp -mfpu=vfp -Os
endif

LDFLAGS=-static 

obj-m += kexec_emulation.o

ifeq ($(cpu), msm7k)
kexec_emulation-objs := kexec.o machine_kexec.o mmu.o sys.o core.o relocate_kernel.o init-mm.o \
	abort-ev6.o proc-v6.o tlb-v6.o cache-v6.o copypage-v6.o entry-common.o driver_sys.o
else ifeq ($(cpu),qsd8k)
kexec_emulation-objs := kexec.o machine_kexec.o mmu.o sys.o core.o relocate_kernel.o init-mm.o \
	abort-ev7.o proc-v7.o tlb-v7.o cache-v7.o copypage-v6.o entry-common.o driver_sys.o
endif
all:
	make -C $(KERNEL_FOLDER) -I $(KERNEL_FOLDER) M=$(PWD) modules

clean:
	rm -rf *.o *.ko *.d .*.o.cmd .*.ko.cmd *.order .tmp_versions Module.symvers Modules.order
