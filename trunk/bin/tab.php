<?php
	if(isset($_REQUEST['fb_sig_user']))
	{
		echo '<fb:swf swfbgcolor="FFFFFF" swfsrc="http://leanmeanhost.co.uk/fb/tab.swf?v=3" width="200" height="400" />';
		return;
	}
?>

<fb:visible-to-connection>

	<div id="update">
		<form action="" id="frm_test" method="post" onsubmit="return false;">
			<input type="button" clickrewriteurl='http://www.leanmeanhost.co.uk/fb/tab.php' clickrewriteform='frm_test' clickrewriteid='update' value="submit"/>
		</form>
	</div>
	
	<fb:else>You need to be a friend</fb:else>

</fb:visible-to-connection>