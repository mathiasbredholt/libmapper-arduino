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

const char *gai_strerror(int);

#ifndef EAI_BADFLAGS
#define EAI_BADFLAGS 205
#endif

#ifndef EAI_AGAIN
#define EAI_AGAIN 206
#endif

#ifndef EAI_SYSTEM
#define EAI_SYSTEM 207
#endif

#ifndef EAI_OVERFLOW
#define EAI_OVERFLOW 208
#endif

#ifndef NI_NUMERICHOST
#define NI_NUMERICHOST 0x02
#endif

#ifndef NI_NUMERICSERV
#define NI_NUMERICSERV 0x08
#endif

#ifndef PF_UNIX
#define PF_UNIX AF_UNIX
#endif
