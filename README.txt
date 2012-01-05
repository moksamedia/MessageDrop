-------------------------------------------


All code (c)2009 Moksa Media all rights reserved
Developer: Andrew Hughes

This file is part of MessageDrop.

MessageDrop is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MessageDrop is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MessageDrop.  If not, see <http://www.gnu.org/licenses/>.


-------------------------------------------


MessageDrop is a location-based or location-aware messaging iPhone app. Users can "drop" messages 
for other users at specific locations.

The basic functionality of the program is operational, although the interface is probably below the 
rigorous eye-candy standards of most iPhone applications. I am making the source code available on 
github because the application demonstrates a few useful functions, such as:

- Using php to expose a web service
- Using php to interface with a MySQL database
- Using NSURLRequest & NSURLConnection to send data via POST
- Accessing Google's mapping API

If you want the program to actually function locally, you will have to move the php files to
a directory locally that is accessible via an apache server with PHP and MySQL installed. MAMP
is a quick way to accomplish this. The database will have to be created and the appropriate
tables built.


-------------------------------------------
