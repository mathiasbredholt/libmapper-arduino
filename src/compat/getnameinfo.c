/*
 libmapper-esp
 Copyright (C) 2020 Mathias Bredholt and Christian Frisson

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

*/

#include <arpa/inet.h>
#include <netdb.h>
#include <stddef.h>
#include <stdio.h>
#include "compat.h"

int getnameinfo(const struct sockaddr *addr, socklen_t addrlen, char *host,
                socklen_t hostlen, char *serv, socklen_t servlen, int flag) {
  if (flag & ~(NI_NUMERICHOST | NI_NUMERICSERV)) {
    return EAI_BADFLAGS;
  }

  const struct sockaddr_in *sinp = (const struct sockaddr_in *)addr;

  if (addr->sa_family == AF_INET) {
    if (flag & NI_NUMERICHOST) {
      if (inet_ntop(AF_INET, &sinp->sin_addr, host, hostlen) == NULL) {
        return EAI_OVERFLOW;
      }
    }
    if (flag & NI_NUMERICSERV) {
      if (snprintf(serv, servlen, "%d", ntohs(sinp->sin_port)) < 0) {
        return EAI_OVERFLOW;
      }
    }
  } else {
    return EAI_FAMILY;
  }
  return 0;
}
