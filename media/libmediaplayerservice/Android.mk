LOCAL_PATH:= $(call my-dir)

#
# libmediaplayerservice
#

include $(CLEAR_VARS)

# RESOURCE MANAGER
ifeq ($(strip $(BOARD_USES_RESOURCE_MANAGER)),true)
LOCAL_CFLAGS += -DRESOURCE_MANAGER
endif
# RESOURCE MANAGER

LOCAL_SRC_FILES:=               \
    ActivityManager.cpp         \
    Crypto.cpp                  \
    Drm.cpp                     \
    HDCP.cpp                    \
    MediaPlayerFactory.cpp      \
    MediaPlayerService.cpp      \
    MediaRecorderClient.cpp     \
    MetadataRetrieverClient.cpp \
    MidiFile.cpp                \
    MidiMetadataRetriever.cpp   \
    RemoteDisplay.cpp           \
    SharedLibrary.cpp           \
    StagefrightPlayer.cpp       \
    StagefrightRecorder.cpp     \
    TestPlayerStub.cpp          \

LOCAL_SHARED_LIBRARIES :=       \
    libbinder                   \
    libcamera_client            \
    libcutils                   \
    liblog                      \
    libdl                       \
    libgui                      \
    libmedia                    \
    libsonivox                  \
    libstagefright              \
    libstagefright_foundation   \
    libstagefright_omx          \
    libstagefright_wfd          \
    libutils                    \
    libdl                       \
    libvorbisidec               \

LOCAL_STATIC_LIBRARIES :=       \
    libstagefright_nuplayer     \
    libstagefright_rtsp         \
    libmedia_helper             \

LOCAL_C_INCLUDES :=                                                 \
    $(call include-path-for, graphics corecg)                       \
    $(TOP)/frameworks/av/media/libstagefright/include               \
    $(TOP)/frameworks/av/media/libstagefright/rtsp                  \
    $(TOP)/frameworks/av/media/libstagefright/wifi-display          \
    $(TOP)/frameworks/native/include/media/openmax                  \
    $(TOP)/external/tremolo/Tremolo                                 \

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
    ifneq ($(TARGET_QCOM_MEDIA_VARIANT),)
        LOCAL_C_INCLUDES += \
            $(TOP)/hardware/qcom/media-$(TARGET_QCOM_MEDIA_VARIANT)/mm-core/inc
    else
        ifeq ($(TARGET_QCOM_DISPLAY_VARIANT),legacy)
            LOCAL_C_INCLUDES += \
                $(TOP)/hardware/qcom/media-legacy/mm-core/inc
        else
            LOCAL_C_INCLUDES += \
                $(TOP)/hardware/qcom/media/mm-core/inc
        endif
    endif
endif

LOCAL_MODULE:= libmediaplayerservice

ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS),true)
    LOCAL_CFLAGS += -DENABLE_QC_AV_ENHANCEMENTS -fno-strict-aliasing
    LOCAL_C_INCLUDES += $(TOP)/frameworks/av/include/media
    ifneq ($(TARGET_QCOM_MEDIA_VARIANT),)
        ifeq ($(TARGET_QCOM_DISPLAY_VARIANT),legacy)
            LOCAL_C_INCLUDES += \
                $(TOP)/hardware/qcom/media-legacy/mm-core/inc
        else
            LOCAL_C_INCLUDES += \
                $(TOP)/hardware/qcom/media/mm-core/inc
        endif
    else
        LOCAL_C_INCLUDES += \
            $(TOP)/hardware/qcom/media/mm-core/inc
    endif
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

include $(BUILD_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))
