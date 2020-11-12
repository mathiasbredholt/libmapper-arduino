/*
 libmapper-esp
 Copyright (C) 2020 Mathias Bredholt

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
