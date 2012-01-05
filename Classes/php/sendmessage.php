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

	$messageText = $_POST['messageText'];
	$hint = $_POST['hint'];
	$sender = $_POST['sender'];
	$receiver = $_POST['receiver'];
	$hasBeenRead = $_POST['hasBeenRead'];
	$hidden = $_POST['hidden'];
	$longitude = $_POST['longitude'];
	$lattitude = $_POST['lattitude'];
	$hitToleranceInMeters = $_POST['hitToleranceInMeters'];
	$locked = $_POST['locked'];
	$data = $_POST['data'];
	
	// Database info
	$database_host = '127.0.0.1';
	$database_user = 'andrewhughes';
	$database_password = 'andrewhughes';
	$database_identifier = 'messagedrop';

	// Connect to mysql
	$databaseConnexion = @mysql_connect($database_host, $database_user, $database_password);
	
	// in case we can't connect, abort
	if (!$databaseConnexion) 
	{
  		echo( "ERROR:Unable to connect to the database server at this time." . mysql_error()  );
  		exit();
	}
	
	
	// open the message drop database
	if (! @mysql_select_db($database_identifier) ) 
	{
  		echo( "ERROR:Unable to locate the message database at this time." );
 		exit();
	}

	$query = "INSERT INTO messages (id, sender, receiver, longitude, lattitude, message, hint, date, hidden, hasBeenRead, hitToleranceInMeters, locked, data) 
							VALUES (NULL, '{$sender}','{$receiver}',{$longitude},{$lattitude},'{$messageText}', '{$hint}', Now(), {$hidden}, {$hasBeenRead}, {$hitToleranceInMeters}, {$locked}, '{$data}' )";
		
	$result = mysql_query($query, $databaseConnexion);

	if (!$result) 
	{	
		echo("<P>Sender: " . $sender . "</P>");
		echo("<P>Receiver: " . $receiver . "</P>");
		echo("<P>Text: " . $messageText . "</P>");
		echo("<P>hasBeenRead: " . $hasBeenRead . "</P>");
		echo("<P>hidden: " . $hidden . "</P>");
		echo("<P>longitude: " . $longitude . "</P>");
		echo("<P>lattitude: " . $lattitude . "</P>");
		echo("<P>hitToleranceInMeters: " . $hitToleranceInMeters . "</P>");
		echo(",P>locked: " . $locked . "</P>");
	
		echo("<P>" . $query. "</P>");
		echo "DB Error, could not query the database\n";
	    echo 'MySQL Error: ' . mysql_error();
	    exit;
	}
	else
	{
		echo "Message Sent";
		//echo $query;
	    exit;
	}
?>