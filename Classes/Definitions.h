//    -------------------------------------------
//
//
//    All code (c)2009 Moksa Media all rights reserved
//    Developer: Andrew Hughes
//
//    This file is part of MessageDrop.
//
//    MessageDrop is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    MessageDrop is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with MessageDrop.  If not, see <http://www.gnu.org/licenses/>.
//
//
//    -------------------------------------------

/*
 *  Definitions.h
 *  Message Drop
 *
 *  Created by Andrew Hughes on 1/4/09.
 *
 */

#define DOWNLOAD_URL @"http://127.0.0.1/~andrewhughes/MessageDrop/checkmail.php"
#define SEND_URL @"http://127.0.0.1/~andrewhughes/MessageDrop/sendmessage.php"
#define ISNAMETAKEN_URL @"http://127.0.0.1/~andrewhughes/MessageDrop/isusernametaken.php"
#define CREATENEWUSER_URL @"http://127.0.0.1/~andrewhughes/MessageDrop/createnewaccount.php"
#define GETMAP_URL @"http://10.0.1.11/~andrewhughes/MessageDrop/getmap.php"

#define PREF_PASSWORD CFSTR("PASSWORD")
#define PREF_USERNAME CFSTR("USERNAME")
#define PREF_IPADDRESS CFSTR("IPADDRESS")
#define PREF_EMAIL CFSTR("EMAIL")

#define DEFAULTS_IPADDRESS @"IPADDRESS"
#define DEFAULTS_USERNAME @"USERNAME"
#define DEFAULTS_PASSWORD @"PASSWORD"
#define DEFAULTS_HASBEENRUN @"HASBEENRUN"

#define MINPASSWORDLENGHT 5
#define ILLEGALCHARACTERS @"./\\*"

#define DEFAULTIPADDDRESS @"127.0.0.1"
#define DEFAULT_MAP_ZOOM_FOR_LOCATION 15
