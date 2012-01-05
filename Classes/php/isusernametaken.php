<?php

    //
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

	// Get query parameters from POST
	//$user = $_POST['user'];
	$user = $_POST['user'];
	
	// Database info
	$database_host = '127.0.0.1';
	$database_user = 'andrewhughes';
	$database_password = 'andrewhughes';
	$database_identifier = 'messagedrop';
	$database_table = 'users';
	
	// Connect to mysql
	$databaseConnexion = @mysql_connect($database_host, $database_user, $database_password);
	
	// in case we can't connect, abort
	if (!$databaseConnexion) 
	{
  		echo( "ERROR: Unable to connect to the database server at this time." . mysql_error()  );
  		exit();
	}
	
	// open the message drop database
	if (! @mysql_select_db($database_identifier) ) 
	{
  		echo( "ERROR: Unable to locate the message database at this time." );
 		exit();
	}
	

	//echo("<P>Connected to database!</P>");
	$query = sprintf("SELECT * FROM $database_table WHERE username='%s'", mysql_real_escape_string($user));
    	
	//echo("<P>" . $query. "</P>");
	
	$result = mysql_query($query, $databaseConnexion);
	
	// get the number of messages
	$numberOfRows = mysql_num_rows($result);

	if (!$result) 
	{
	    echo "ERROR: could not query the database.";
	    echo 'MySQL Error: ' . mysql_error();
	    exit;
	}
	
	if ($numberOfRows > 0) echo("YES");
	else echo("NO");
	
	
?>