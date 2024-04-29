/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.blockstream.libgreenaddress;

public class GDKJNI {

    private static boolean loadLibrary() {
        try {
            System.loadLibrary("greenaddress");
            return true;
        } catch (final UnsatisfiedLinkError e) {
            System.err.println("Native code library failed to load.\n" + e);
            return false;
        }
    }

    private static final boolean enabled = loadLibrary();
    public static boolean isEnabled() {
        return enabled;
    }

    // JSON conversion
    public interface JSONConverter {
       Object toJSONObject(final String jsonString);
       String toJSONString(final Object jsonObject);
    }

    private static JSONConverter mJSONConverter = null;

    private static Object toJSONObject(final String jsonString) {
        return mJSONConverter.toJSONObject(jsonString);
    }

    private static String toJSONString(final Object jsonObject) {
        return mJSONConverter.toJSONString(jsonObject);
    }

    public static void init(JSONConverter _JSONConverter, final Object config) {
        mJSONConverter = _JSONConverter;
        _internal_GA_init(config);
    }

    // Notifications
    public interface NotificationHandler {
       void onNewNotification(final Object session, final Object jsonObject);
    }

    private static NotificationHandler mNotificationHandler = null;

    public static void setNotificationHandler(final NotificationHandler notificationHandler) {
        mNotificationHandler = notificationHandler;
    }

    private static void callNotificationHandler(final Object session, final Object jsonObject) {
        if (mNotificationHandler != null)
            mNotificationHandler.onNewNotification(session, jsonObject);
    }

    static final class Obj {
        private final transient long ptr;
        private final int id;
        private Obj(final long ptr, final int id) { this.ptr = ptr; this.id = id; }
        private long get() { return ptr; }
        private int get_id() { return id; }
    }

  public final static native void _internal_GA_init(Object jarg1);
  public final static native Object create_session();
  public final static native void destroy_session(Object jarg1);
  public final static native void connect(Object jarg1, Object jarg2);
  public final static native void reconnect_hint(Object jarg1, Object jarg2);
  public final static native Object get_proxy_settings(Object jarg1);
  public final static native Object get_wallet_identifier(Object jarg1, Object jarg2);
  public final static native Object http_request(Object jarg1, Object jarg2);
  public final static native void refresh_assets(Object jarg1, Object jarg2);
  public final static native Object get_assets(Object jarg1, Object jarg2);
  public final static native Object validate_asset_domain_name(Object jarg1, Object jarg2);
  public final static native Object validate(Object jarg1, Object jarg2);
  public final static native Object register_user(Object jarg1, Object jarg2, Object jarg3);
  public final static native Object login_user(Object jarg1, Object jarg2, Object jarg3);
  public final static native void set_watch_only(Object jarg1, String jarg2, String jarg3);
  public final static native String get_watch_only_username(Object jarg1);
  public final static native Object remove_account(Object jarg1);
  public final static native Object create_subaccount(Object jarg1, Object jarg2);
  public final static native Object get_subaccounts(Object jarg1, Object jarg2);
  public final static native Object get_subaccount(Object jarg1, long jarg2);
  public final static native void rename_subaccount(Object jarg1, long jarg2, String jarg3);
  public final static native Object update_subaccount(Object jarg1, Object jarg2);
  public final static native Object get_transactions(Object jarg1, Object jarg2);
  public final static native Object get_receive_address(Object jarg1, Object jarg2);
  public final static native Object get_previous_addresses(Object jarg1, Object jarg2);
  public final static native Object get_unspent_outputs(Object jarg1, Object jarg2);
  public final static native Object get_unspent_outputs_for_private_key(Object jarg1, Object jarg2);
  public final static native Object set_unspent_outputs_status(Object jarg1, Object jarg2);
  public final static native Object get_transaction_details(Object jarg1, String jarg2);
  public final static native Object get_balance(Object jarg1, Object jarg2);
  public final static native Object get_available_currencies(Object jarg1);
  public final static native Object convert_amount(Object jarg1, Object jarg2);
  public final static native Object encrypt_with_pin(Object jarg1, Object jarg2);
  public final static native Object decrypt_with_pin(Object jarg1, Object jarg2);
  public final static native void disable_all_pin_logins(Object jarg1);
  public final static native Object create_transaction(Object jarg1, Object jarg2);
  public final static native Object blind_transaction(Object jarg1, Object jarg2);
  public final static native Object sign_transaction(Object jarg1, Object jarg2);
  public final static native Object create_swap_transaction(Object jarg1, Object jarg2);
  public final static native Object complete_swap_transaction(Object jarg1, Object jarg2);
  public final static native Object psbt_sign(Object jarg1, Object jarg2);
  public final static native Object psbt_from_json(Object jarg1, Object jarg2);
  public final static native Object psbt_get_details(Object jarg1, Object jarg2);
  public final static native String broadcast_transaction(Object jarg1, String jarg2);
  public final static native Object send_transaction(Object jarg1, Object jarg2);
  public final static native Object sign_message(Object jarg1, Object jarg2);
  public final static native void send_nlocktimes(Object jarg1);
  public final static native Object set_csvtime(Object jarg1, Object jarg2);
  public final static native Object set_nlocktime(Object jarg1, Object jarg2);
  public final static native void set_transaction_memo(Object jarg1, String jarg2, String jarg3, long jarg4);
  public final static native Object get_fee_estimates(Object jarg1);
  public final static native Object get_credentials(Object jarg1, Object jarg2);
  public final static native String get_system_message(Object jarg1);
  public final static native Object ack_system_message(Object jarg1, String jarg2);
  public final static native Object get_twofactor_config(Object jarg1);
  public final static native Object change_settings(Object jarg1, Object jarg2);
  public final static native Object get_settings(Object jarg1);
  public final static native Object auth_handler_get_status(Object jarg1);
  public final static native void auth_handler_request_code(Object jarg1, String jarg2);
  public final static native void auth_handler_resolve_code(Object jarg1, String jarg2);
  public final static native void auth_handler_call(Object jarg1);
  public final static native void destroy_auth_handler(Object jarg1);
  public final static native Object change_settings_twofactor(Object jarg1, String jarg2, Object jarg3);
  public final static native Object twofactor_reset(Object jarg1, String jarg2, long jarg3);
  public final static native Object twofactor_undo_reset(Object jarg1, String jarg2);
  public final static native Object twofactor_cancel_reset(Object jarg1);
  public final static native Object twofactor_change_limits(Object jarg1, Object jarg2);
  public final static native Object bcur_encode(Object jarg1, Object jarg2);
  public final static native Object bcur_decode(Object jarg1, Object jarg2);
  public final static native byte[] get_random_bytes(long jarg1, long jarg2, long jarg3);
  public final static native String generate_mnemonic();
  public final static native String generate_mnemonic_12();
  public final static native long validate_mnemonic(String jarg1);
  public final static native void register_network(String jarg1, Object jarg2);
  public final static native Object get_networks();
  public final static native long get_uniform_uint32_t(long jarg1);

  public final static int GA_OK = 0;
  public final static int GA_ERROR = (-1);
  public final static int GA_RECONNECT = (-2);
  public final static int GA_SESSION_LOST = (-3);
  public final static int GA_TIMEOUT = (-4);
  public final static int GA_NOT_AUTHORIZED = (-5);
  public final static int GA_NONE = 0;
  public final static int GA_INFO = 1;
  public final static int GA_DEBUG = 2;
  public final static int GA_TRUE = 1;
  public final static int GA_FALSE = 0;

  public final static byte[] get_random_bytes(long jarg1) {
      return get_random_bytes(jarg1, 0, 0);
  }
}
