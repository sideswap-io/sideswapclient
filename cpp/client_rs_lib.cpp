#include "client_rs_lib.h"

namespace lsw {

namespace {

Callbacks g_callbacks;

}

void registerCallbacks(Callbacks callbacks) {
    g_callbacks = std::move(callbacks);
}

void update_state(rust::Str data) {
    g_callbacks.updateStateCb(data);
}

void update_history(rust::Str data) {
    g_callbacks.updateHistoryCb(data);
}

void show_notification(rust::Str data) {
    g_callbacks.showNotificationCb(data);
}

void update_walletinfo(rust::Str data)
{
    g_callbacks.updateWalletinfoCb(data);
}

void tx_broadcasted(rust::Str data)
{
    g_callbacks.txBroadcastedCb(data);
}

void update_assets(rust::Str data)
{
    g_callbacks.updateAssets(data);
}

void update_orders(rust::Str data)
{
    g_callbacks.updateOrders(data);
}

void update_rfq_client(rust::Str data)
{
    g_callbacks.updateRfqClient(data);
}

void update_wallets_list(rust::Str data)
{
    g_callbacks.updateWalletsList(data);
}

void apply_wallets_result(rust::Str data) {
   g_callbacks.applyWalletsResult(data);
}

void update_asset_image(rust::Str name, rust::Slice<uint8_t> image)
{
   g_callbacks.updateAssetImage(name, image);
}

}

#include "client_rs_gen.cpp"
