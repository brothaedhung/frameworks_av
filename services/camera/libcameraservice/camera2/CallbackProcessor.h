/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef ANDROID_SERVERS_CAMERA_CAMERA2_CALLBACKPROCESSOR_H
#define ANDROID_SERVERS_CAMERA_CAMERA2_CALLBACKPROCESSOR_H

#include <utils/Thread.h>
#include <utils/String16.h>
#include <utils/Vector.h>
#include <utils/Mutex.h>
#include <utils/Condition.h>
#include <gui/CpuConsumer.h>
#include "Parameters.h"
#include "CameraMetadata.h"
#include "Camera2Heap.h"

namespace android {

class Camera2Client;

namespace camera2 {

/***
 * Still image capture output image processing
 */
class CallbackProcessor:
            public Thread, public CpuConsumer::FrameAvailableListener {
  public:
    CallbackProcessor(wp<Camera2Client> client);
    ~CallbackProcessor();

    void onFrameAvailable();

    status_t updateStream(const Parameters &params);
    status_t deleteStream();
    int getStreamId() const;

    void dump(int fd, const Vector<String16>& args);
  private:
    static const nsecs_t kWaitDuration = 10000000; // 10 ms
    wp<Camera2Client> mClient;

    mutable Mutex mInputMutex;
    bool mCallbackAvailable;
    Condition mCallbackAvailableSignal;

    enum {
        NO_STREAM = -1
    };

    int mCallbackStreamId;
    static const size_t kCallbackHeapCount = 6;
    sp<CpuConsumer>    mCallbackConsumer;
    sp<ANativeWindow>  mCallbackWindow;
    sp<Camera2Heap>    mCallbackHeap;
    int mCallbackHeapId;
    size_t mCallbackHeapHead, mCallbackHeapFree;

    virtual bool threadLoop();

    status_t processNewCallback(sp<Camera2Client> &client);

};


}; //namespace camera2
}; //namespace android

#endif