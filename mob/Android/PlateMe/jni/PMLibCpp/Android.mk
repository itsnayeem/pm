LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CPP_FEATURES := rtti exceptions

MY_PMLIBCPP_SRC := ../../../../common/PMLibCpp
MY_PMLIBCPP_INC := $(LOCAL_PATH)/../../../../common/PMLibCpp

LOCAL_C_INCLUDES := $(MY_PMLIBCPP_INC) \
                    $(MY_PMLIBCPP_INC)/../JSONCpp/include \
                    $(MY_PMLIBCPP_INC)/../libcurl/include \
                    $(MY_PMLIBCPP_INC)/../libcurl/lib
                    
LOCAL_MODULE    := PMLibCpp
LOCAL_SRC_FILES := $(MY_PMLIBCPP_SRC)/PMLibCpp.cpp \
                   $(MY_PMLIBCPP_SRC)/PMServer.cpp \
                   $(MY_PMLIBCPP_SRC)/PMServerHelper.cpp

include $(BUILD_STATIC_LIBRARY)
