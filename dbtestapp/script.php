<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "TestDB";
$table = "Employees"; // lets create a table named Employees.
// we will get actions from the app to do operations in the database...

// Create Connection
$conn = new mysqli($servername, $username, $password, $dbname);
$action = isset($_POST["action"]) ? $_POST["action"] : ""; // lets get the action

// Check Connection
if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
    echo 'action: ' . $action;

    return;
} else {
    echo ('Connected');
    // echo 'action: ' . $action;
}

// If connection is OK...

// If the app sends an action to create the table...
if ("CREATE_TABLE" == $action) {
    $sql = "CREATE TABLE IF NOT EXISTS $table ( 
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            first_name VARCHAR(30) NOT NULL,
            last_name VARCHAR(30) NOT NULL
            )";

    if ($conn->query($sql) === TRUE) {
        // send back success message
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    echo ('Create');
    return;
}

// Get all employee records from the database
if ("GET_ALL" == $action) {
    echo ("Get All");
    $db_data = array();
    $sql = "SELECT id, first_name, last_name from $table ORDER BY id DESC";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        echo json_encode($db_data);
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Add an Employee
if ("ADD_EMP" == $action) {
    echo ("Add Emp");
    // App will be posting these values to this server
    $first_name = $_POST["first_name"];
    $last_name = $_POST["last_name"];
    $sql = "INSERT INTO $table (first_name, last_name) VALUES ('$first_name', '$last_name')";
    $result = $conn->query($sql);
    echo "success";
    $conn->close();
    return;
}

// Remember - this is the server file.
// I am updating the server file.
// Update an Employee
if ("UPDATE_EMP" == $action) {
    // App will be posting these values to this server
    $emp_id = $_POST['emp_id'];
    $first_name = $_POST["first_name"];
    $last_name = $_POST["last_name"];
    $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name' WHERE id = $emp_id";
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Delete an Employee
if ('DELETE_EMP' == $action) {
    $emp_id = $_POST['emp_id'];
    $sql = "DELETE FROM $table WHERE id = $emp_id"; // don't need quotes since id is an integer.
    if ($conn->query($sql) === TRUE) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}
