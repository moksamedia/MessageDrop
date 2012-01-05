<?php

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