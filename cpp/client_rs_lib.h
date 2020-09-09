#pragma once
#include <utility>
#include <functional>

#include "cxx.h"

namespace lsw {

enum class MessageType : uint8_t;

using StringCallback = std::function<void(rust::Str state)>;

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

}
