<html>
  <head>
    <title>esp table</title>
  </head>
  <body>
    <?php
      require_once('sqlite3.php');
      $sql = new DB('arduino.db');
      $sql->create('arduino.db');
      $sql->selectAll('esp');
    ?> 
  </body>
</html>
