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
	$password = $_POST['password'];
	
	// Database info
	$database_host = '127.0.0.1';
	$database_user = 'andrewhughes';
	$database_password = 'andrewhughes';
	$database_identifier = 'messagedrop';
	$database_table = 'messages';
	
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

	$query = sprintf("SELECT * FROM users WHERE username = '%s' ", mysql_real_escape_string($user) );
	
	$result = mysql_query($query, $databaseConnexion);

	$row = mysql_fetch_assoc($result);
	
	$dbpassword = $row['password'];
	$encrypted_password = crypt($password, $dbpassword);
	
	if ($dbpassword != $encrypted_password)
	{
		echo("ERROR:wrong password for username!");
		exit;
	}
	
	
	//echo("<P>Connected to database!</P>");
	$query = sprintf("SELECT * FROM messages WHERE receiver='%s'", mysql_real_escape_string($user));
    	
	//echo("<P>" . $query. "</P>");
	
	$result = mysql_query($query, $databaseConnexion);
	
	// get the number of messages
	$numberOfMessages = mysql_num_rows($result);

	if (!$result) 
	{
	    echo "ERROR:could not query the database\n";
	    echo 'MySQL Error: ' . mysql_error();
	    exit;
	}
	
	// Make the XML respons
	
	$m = new SimpleXMLElement('<xml></xml>');
	
	$m->addAttribute('numberOfMessages', $numberOfMessages);
	
	//echo "<P> You have received " . $numberOfMessages . " messages. </P>";
	
	$i = 1;
	
	while ($row = mysql_fetch_assoc($result)) 
	{
	    //echo("<P>". $row['sender'] . " sent you: " . $row['message'] . "</P>");
		$message = $m->addChild("message");
		$message->addAttribute('sender', $row['sender']);
		$message->addAttribute('receiver', $row['receiver']);
		$message->addAttribute('messageText', $row['message']);
		$message->addAttribute('hint', $row['hint']);
		$message->addAttribute('hasBeenRead', $row['hasBeenRead']);
		$message->addAttribute('hidden', $row['hidden']);
		$message->addAttribute('longitude', $row['longitude']);
		$message->addAttribute('lattitude', $row['lattitude']);
		$message->addAttribute('hitToleranceInMeters', $row['hitToleranceInMeters']);
		$message->addAttribute('locked', $row['locked']);
		$message->addAttribute('data', $row['data']);
		
		$i++;
	}
	
	echo $m->asXML();
		
	mysql_free_result($result);
	unset($m);
	
	
?>