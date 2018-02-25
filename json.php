
<?php

	define("DB_DSN",'db_json');
	define("DB_HOST",'localhost');
	define("DB_USER",'-');
	define("DB_PASS",'-');

	$link = mysql_connect(DB_HOST, DB_USER, DB_PASS) or die('Could not connect: ' . mysql_error());
	mysql_select_db(DB_DSN) or die('Could not select database');

	if(isset($_GET)) {
	    $userid = base64_decode($_GET["userid"]);
	    $password = base64_decode($_GET["password"]);
	    $query = 'SELECT * FROM players WHERE userid="' . mysql_real_escape_string($userid) . '"';
	    $dbresult = mysql_query($query, $link);
	    if (!$dbresult) {
	        $result = array();
	        $result["result"] = 403;
	        $result["message"] = mysql_error();
	        echo json_encode($result);
	        mysql_free_result($dbresult);
	        exit;
	    }
		// DEBUG
	    $player = mysql_fetch_array($dbresult, MYSQL_ASSOC);
	    if (strcmp($player["password"], md5($password)) == 0) {
	        $result = array();
	        $result["result"] = 200;
	        $result["message"] = "Success";
	        $result["userid"] = $player["userid"];
	        $result["firstname"] = $player["firstname"];
	        $result["lastname"] = $player["lastname"];
	        $query = sprintf("UPDATE players SET lastlogin=NOW() WHERE id=%s;", $player["id"]);
	        $uresult = mysql_query($query, $link);
	        if ($uresult) {

	        }
	        echo json_encode($result);
	    } else {
	        $result = array();
	        $result["result"] = 403;
	        $result["message"] = "Forbidden - Bad Password";
	        echo json_encode($result);
	    }

	} else {
	    $result = array();
	    $result["result"] = 400;
	    $result["message"] = "Bad Request";
	    echo json_encode($result);
	}
	exit;

?>
