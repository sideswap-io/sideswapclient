#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define SIDESWAP_BITCOIN 1

#define SIDESWAP_ELEMENTS 2

#define SIDESWAP_ENV_PROD 0

#define SIDESWAP_ENV_TESTNET 5

#define SIDESWAP_ENV_LOCAL_LIQUID 4

#define SIDESWAP_ENV_LOCAL_TESTNET 6

typedef uint64_t IntPtr;

IntPtr sideswap_client_start(int32_t env,
                             const char *work_dir,
                             const char *version,
                             int64_t dart_port);

void sideswap_send_request(IntPtr client, const uint8_t *data, uint64_t len);

void sideswap_process_background(const char *data);

bool sideswap_check_addr(IntPtr client, const char *addr, int32_t addr_type);

const uint8_t *sideswap_msg_ptr(IntPtr msg);

uint64_t sideswap_msg_len(IntPtr msg);

void sideswap_msg_free(IntPtr msg);

char *sideswap_generate_mnemonic12(void);

bool sideswap_verify_mnemonic(const char *mnemonic);

void sideswap_string_free(char *str);
