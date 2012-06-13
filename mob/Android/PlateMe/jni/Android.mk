include $(call all-subdir-makefiles)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_STATIC_LIBRARIES := JSONCpp curl PMLibCpp                  

LOCAL_MODULE := PMCpp

include $(BUILD_SHARED_LIBRARY)