
LOCAL_PATH:= $(call my-dir)

CFLAGS := -Wpointer-arith -Wwrite-strings -Wunused -Winline \
 -Wnested-externs -Wmissing-declarations -Wmissing-prototypes -Wno-long-long \
 -Wfloat-equal -Wno-multichar -Wsign-compare -Wno-format-nonliteral \
 -Wendif-labels -Wstrict-prototypes -Wdeclaration-after-statement \
 -Wno-system-headers -DHAVE_CONFIG_H

include $(CLEAR_VARS)

MY_CURL_SRC := ../../../../common/libcurl/lib
MY_CURL_INC := $(LOCAL_PATH)/../../../../common/libcurl

include $(LOCAL_PATH)/$(MY_CURL_SRC)/Makefile.inc

LOCAL_SRC_FILES := $(addprefix $(MY_CURL_SRC)/,$(CSOURCES))
LOCAL_CFLAGS += $(CFLAGS)
LOCAL_C_INCLUDES := $(MY_CURL_INC)/include $(MY_CURL_INC)/lib

LOCAL_MODULE:= curl

include $(BUILD_STATIC_LIBRARY)

