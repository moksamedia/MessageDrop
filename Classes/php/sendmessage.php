<?php
	
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