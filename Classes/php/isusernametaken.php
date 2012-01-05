<?php

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