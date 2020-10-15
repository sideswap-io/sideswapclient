#pragma once
#include <utility>
#include <functional>

#include "cxx.h"

namespace lsw {

enum class MessageType : uint8_t;
struct Asset;

using StringCallback = std::function<void(rust::Str state)>;

using UpdateAssetImageCallback = std::function<void(rust::Str state, rust::Slice<uint8_t> image)>;

struct Callbacks {
    StringCallback updateStateCb;
    StringCallback updateHistoryCb;
    StringCallback updateWalletinfoCb;
    StringCallback showNotificationCb;
    StringCallback txBroadcastedCb;
    StringCallback updateAssets;
    StringCallback updateOrders;
    StringCallback updateRfqClient;
    StringCallback updateWalletsList;
    StringCallback applyWalletsResult;
    UpdateAssetImageCallback updateAssetImage;
};

void registerCallbacks(Callbacks callbacks);

void update_state(rust::Str data);
void update_history(rust::Str data);
void update_walletinfo(rust::Str data);
void show_notification(rust::Str data);
void tx_broadcasted(rust::Str data);
void update_assets(rust::Str data);
void update_orders(rust::Str data);
void update_rfq_client(rust::Str data);
void update_asset_image(rust::Str name, rust::Slice<uint8_t> image);


}
