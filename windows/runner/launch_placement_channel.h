#ifndef RUNNER_LAUNCH_PLACEMENT_CHANNEL_H_
#define RUNNER_LAUNCH_PLACEMENT_CHANNEL_H_

#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <windows.h>

#include <functional>
#include <memory>

// The app's Windows placement channel: the work area of the display under the
// cursor, and a window centred on that display in physical pixels.
//
// Both live here rather than in Dart because Dart cannot express them. The
// plugins divide a display origin by that display's DPI scale, the cursor by
// the current Flutter view's device pixel ratio, and multiply a `setBounds`
// position back by that same current ratio, so on a mixed-DPI desktop the
// three answers are in incompatible units. Selecting the monitor and moving
// the window in one native call in physical pixels is what makes the answer
// usable. See ADR-0014 decision 3, as amended by #261.
namespace launch_placement_channel {

// |get_window| answers the app's top-level window, read lazily at invoke time
// rather than captured: the handle is null once the window is destroyed.
std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> Register(
    flutter::BinaryMessenger* messenger,
    std::function<HWND()> get_window);

}  // namespace launch_placement_channel

#endif  // RUNNER_LAUNCH_PLACEMENT_CHANNEL_H_
