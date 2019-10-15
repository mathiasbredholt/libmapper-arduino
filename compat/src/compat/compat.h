#include "lwip/inet.h"
#include "net/if.h"

const char *gai_strerror(int);

#define PF_INET AF_INET

#define PF_UNIX AF_UNIX

#define NI_NUMERICHOST  0x02

#ifndef EAI_OVERFLOW
#define EAI_OVERFLOW    205
#endif

#ifndef EAI_AGAIN
#define EAI_AGAIN        2   /* temporary failure in name resolution */
#endif

#ifndef EAI_BADFLAGS
#define EAI_BADFLAGS     3   /* invalid value for ai_flags */
#endif
