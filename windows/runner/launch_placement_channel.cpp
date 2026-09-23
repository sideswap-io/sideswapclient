#include "launch_placement_channel.h"

#include <flutter/standard_method_codec.h>
#include <flutter_windows.h>

#include <algorithm>
#include <cmath>
#include <string>

namespace launch_placement_channel {

namespace {

using MethodResult = flutter::MethodResult<flutter::EncodableValue>;

constexpr char kChannelName[] = "app.sideswap.io/launch_placement";
constexpr double kBaseDpi = 96.0;

LONG RectWidth(const RECT& rect) { return rect.right - rect.left; }

LONG RectHeight(const RECT& rect) { return rect.bottom - rect.top; }

// The monitor the window is meant to open on: the one under the cursor, with
// the primary as the fallback. `MONITOR_DEFAULTTOPRIMARY` is that fallback,
// and it also answers a cursor position no monitor contains — the case that
// sends `calcWindowPosition` to the primary in Dart today.
HMONITOR MonitorUnderCursor() {
  POINT cursor = {0, 0};
  ::GetCursorPos(&cursor);
  return ::MonitorFromPoint(cursor, MONITOR_DEFAULTTOPRIMARY);
}

// The scale that turns this monitor's logical pixels into physical ones.
// The same figure `screen_retriever` divides `rcWork` by, read through the
// same Flutter helper the runner already uses for the launch size, so the
// work area this channel reports and the one the plugin reports are the same
// number in the same units.
double ScaleFactorOf(HMONITOR monitor) {
  return ::FlutterDesktopGetDpiForMonitor(monitor) / kBaseDpi;
}

// Reads |key| from |args| as a double. Returns false when the argument is not
// a map, the key is absent, or the value is not a finite positive number.
bool ReadDimension(const flutter::EncodableValue& args,
                   const char* key,
                   double* out) {
  const auto* map = std::get_if<flutter::EncodableMap>(&args);
  if (map == nullptr) {
    return false;
  }
  const auto entry = map->find(flutter::EncodableValue(key));
  if (entry == map->end()) {
    return false;
  }
  const auto* value = std::get_if<double>(&entry->second);
  if (value == nullptr || !std::isfinite(*value) || *value <= 0) {
    return false;
  }
  *out = *value;
  return true;
}

// Answers with the work area of |info|'s monitor in that monitor's own
// logical pixels — the units `screen_retriever` reports, so the fallback
// path sizes the window from the same numbers.
void RespondWithWorkArea(const MONITORINFO& info,
                         double scale_factor,
                         MethodResult& result) {
  flutter::EncodableMap work_area;
  work_area[flutter::EncodableValue("width")] =
      flutter::EncodableValue(std::round(RectWidth(info.rcWork) / scale_factor));
  work_area[flutter::EncodableValue("height")] = flutter::EncodableValue(
      std::round(RectHeight(info.rcWork) / scale_factor));
  result.Success(flutter::EncodableValue(work_area));
}

// How many times the placement is written before it gives up.
//
// More than one because moving to a monitor with another DPI raises
// `WM_DPICHANGED`, and the runner honours the rectangle Windows suggests
// (`win32_window.cpp`, `WM_DPICHANGED`), which overwrites the one written
// here. The same message also refreshes the plugin's `pixel_ratio_`, which
// is what its `WM_GETMINMAXINFO` handler scales the minimum track size by, so
// a request clamped against the *creating* monitor's ratio stops being
// clamped once the move has landed. Both settle on the next write; the third
// attempt is slack, not a loop that hopes.
constexpr int kPlacementAttempts = 3;

// Centres a window of |logical_width| by |logical_height| in |info|'s work
// area and moves |window| there, all in physical pixels.
//
// Returns whether the window ended up in the rectangle asked for. False is a
// real answer the caller acts on: Windows clamps a programmatic `SetWindowPos`
// to the window's minimum track size, so a request the OS refuses must reach
// Dart rather than be reported as placed.
bool PlaceWindow(HWND window,
                 const MONITORINFO& info,
                 double scale_factor,
                 double logical_width,
                 double logical_height) {
  const int width = static_cast<int>(std::lround(logical_width * scale_factor));
  const int height =
      static_cast<int>(std::lround(logical_height * scale_factor));
  // Clamped to the work area's origin: a window wider or taller than the
  // display it opens on starts inside the work area rather than half off the
  // top-left of it.
  const int x = std::max<int>(
      info.rcWork.left,
      info.rcWork.left + (RectWidth(info.rcWork) - width) / 2);
  const int y = std::max<int>(
      info.rcWork.top,
      info.rcWork.top + (RectHeight(info.rcWork) - height) / 2);

  for (int attempt = 0; attempt < kPlacementAttempts; ++attempt) {
    ::SetWindowPos(window, nullptr, x, y, width, height,
                   SWP_NOZORDER | SWP_NOACTIVATE);

    RECT placed;
    if (!::GetWindowRect(window, &placed)) {
      return false;
    }
    if (placed.left == x && placed.top == y && RectWidth(placed) == width &&
        RectHeight(placed) == height) {
      return true;
    }
  }
  return false;
}

}  // namespace

std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> Register(
    flutter::BinaryMessenger* messenger,
    std::function<HWND()> get_window) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          messenger, kChannelName,
          &flutter::StandardMethodCodec::GetInstance());

  // The monitor `readLaunchWorkArea` answered for, latched so that
  // `placeLaunchWindow` centres on the display the size was computed from.
  // The two methods are separate hops with the window's own setup between
  // them, and the user can move the cursor across a display boundary in that
  // time; without the latch the window would be sized for one display and
  // placed on another. Null until the first query, which is the mobile-mode
  // path: it asks for no work area, so it places under the cursor.
  auto latched_monitor = std::make_shared<HMONITOR>(nullptr);

  channel->SetMethodCallHandler(
      [get_window, latched_monitor](
          const flutter::MethodCall<flutter::EncodableValue>& call,
          std::unique_ptr<MethodResult> result) {
        const bool is_work_area = call.method_name() == "readLaunchWorkArea";
        const bool is_place = call.method_name() == "placeLaunchWindow";
        if (!is_work_area && !is_place) {
          result->NotImplemented();
          return;
        }

        // A latched handle goes stale when the display layout changes, and
        // `GetMonitorInfo` is what says so. Falling back to the cursor then is
        // the same answer this channel gives with nothing latched at all.
        HMONITOR monitor = nullptr;
        MONITORINFO info;
        info.cbSize = sizeof(MONITORINFO);
        if (is_place && *latched_monitor != nullptr) {
          monitor = *latched_monitor;
          if (!::GetMonitorInfo(monitor, &info)) {
            monitor = nullptr;
          }
        }
        if (monitor == nullptr) {
          monitor = MonitorUnderCursor();
          info.cbSize = sizeof(MONITORINFO);
          if (!::GetMonitorInfo(monitor, &info)) {
            result->Error("no_monitor",
                          "Windows reported no monitor under the cursor");
            return;
          }
        }
        const double scale_factor = ScaleFactorOf(monitor);

        if (is_work_area) {
          *latched_monitor = monitor;
          RespondWithWorkArea(info, scale_factor, *result);
          return;
        }

        double logical_width = 0;
        double logical_height = 0;
        const auto* args = call.arguments();
        if (args == nullptr ||
            !ReadDimension(*args, "width", &logical_width) ||
            !ReadDimension(*args, "height", &logical_height)) {
          result->Error("bad_argument",
                        "placeLaunchWindow needs a logical window size");
          return;
        }

        HWND window = get_window();
        if (window == nullptr) {
          result->Error("no_window", "The app has no top-level window");
          return;
        }

        result->Success(flutter::EncodableValue(PlaceWindow(
            window, info, scale_factor, logical_width, logical_height)));
      });

  return channel;
}

}  // namespace launch_placement_channel
