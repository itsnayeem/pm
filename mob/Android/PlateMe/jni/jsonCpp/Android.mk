LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CPP_FEATURES := rtti exceptions

MY_JSONCPP_SRC := ../../../../common/jsonCpp/src/lib_json
MY_JSONCPP_INC := $(LOCAL_PATH)/../../../../common/jsonCpp/include

LOCAL_C_INCLUDES := $(MY_JSONCPP_INC)
LOCAL_MODULE    := JSONCpp
LOCAL_SRC_FILES := $(MY_JSONCPP_SRC)/json_internalarray.inl \
                   $(MY_JSONCPP_SRC)/json_internalmap.inl \
                   $(MY_JSONCPP_SRC)/json_valueiterator.inl \
                   $(MY_JSONCPP_SRC)/json_reader.cpp \
                   $(MY_JSONCPP_SRC)/json_value.cpp \
                   $(MY_JSONCPP_SRC)/json_writer.cpp

include $(BUILD_STATIC_LIBRARY)
