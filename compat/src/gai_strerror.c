#include "compat.h"
#include "lwip/netdb.h"

const char *gai_strerror(int errnum) {
    switch (errnum) {
    case 0:
        return "no error";
    case EAI_NONAME:
        return "name or service is not known";
    case EAI_FAIL:
        return "non-recoverable failure in name resolution";
    case EAI_FAMILY:
        return "ai_family not supported";
    case EAI_SERVICE:
        return "service not supported for ai_socktype";
    case EAI_MEMORY:
        return "memory allocation failure";
    case EAI_SYSTEM:
        return "system failure";
    default:
        return "unknown/invalid error";
    }
}