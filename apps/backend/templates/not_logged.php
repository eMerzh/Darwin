<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <?php include_http_metas() ?>
    <?php include_metas() ?>
    <?php include_title() ?>
    <link rel="shortcut icon" href="/favicon.ico" />
  </head>
  <body id="login_page">
    <h2>Not LOGGED</h2>
    <?php echo $sf_content ?>

<script language="javascript" type="text/javascript"> 
$(document).ready(function () {

  if($('.menu_top .house').length)
        location.reload();
});
  </script>
  </body>
</html>