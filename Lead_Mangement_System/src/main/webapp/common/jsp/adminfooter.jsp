<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="./common/bootstrap/bootstrap.min.js"></script>
<script src="./common/bootstrap/bootstrap.bundle.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(".nav").click(function(){
	$("#mySidenav").css('width','70px');
	$("#main").css('margin-left','70px');
	$(".logo").attr('hidden', 'true');
	$(".logo span").css('visibility', 'visible');
	$(".logo span").css('margin-left', '-10px');
	$(".icon-a").css('visibility', 'hidden');
	$(".icons").css('visibility', 'visible');
	$(".icons").css('margin-left', '-8px');
	$(".nav").css('display','none');
	$(".nav2").css('display','block');
	});
	
	$(".nav2").click(function(){
	$("#mySidenav").css('width','300px');
	$("#main").css('margin-left','300px');
	$(".logo").removeAttr('hidden', 'false');
	$(".icon-a").css('visibility', 'visible');
	$(".icons").css('visibility', 'visible');
	$(".nav").css('display','block');
	$(".nav2").css('display','none');
	});
</script>