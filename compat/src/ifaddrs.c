#include <ifaddrs.h>
#include "tcpip_adapter.h"

int getifaddrs(struct ifaddrs **ifap) {
    struct ifaddrs* ifa;
    struct sockaddr_in *sa;
    ifa = (struct ifaddrs*) malloc(sizeof(struct ifaddrs));
    memset(ifa, 0, sizeof(struct ifaddrs));

    // Flags
    ifa->ifa_flags = IFF_UP;

    // Name
    const int NAME_LENGTH = 16;
    ifa->ifa_name = malloc(NAME_LENGTH);
    snprintf(ifa->ifa_name, NAME_LENGTH, "ESP32_STA");

    // Address
    tcpip_adapter_ip_info_t ip_info;
    ESP_ERROR_CHECK(tcpip_adapter_get_ip_info(TCPIP_ADAPTER_IF_STA, &ip_info));

    ifa->ifa_addr = (struct sockaddr*) malloc(sizeof(struct sockaddr_in));
    sa = (struct sockaddr_in*) ifa->ifa_addr;
    sa->sin_family = AF_INET;
    sa->sin_addr.s_addr = ip_info.ip.addr;
    *ifap = ifa;
    return 0;
}

void freeifaddrs(struct ifaddrs *ifa) {
    struct ifaddrs *p, *q;
    for (p = ifa; p; ) {
        free(p->ifa_name);
        if (p->ifa_addr)
            free(p->ifa_addr);
        if (p->ifa_dstaddr)
            free(p->ifa_dstaddr);
        if (p->ifa_netmask)
            free(p->ifa_netmask);
        if (p->ifa_data)
            free(p->ifa_data);
        q = p;
        p = p->ifa_next;
        free(q);
    }
}
