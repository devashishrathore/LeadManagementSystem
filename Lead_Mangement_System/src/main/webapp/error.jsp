<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
 <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>404 error</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
    />

    <link rel="stylesheet" href="login.css" />
<title>Login test</title>
<style>
	*{
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body{
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    letter-spacing: 1px;
    background-color: #0c1022;
}
.login_form_container{
    position: relative;
    width: 400px;
    height: 470px;
    max-width: 400px;
    max-height: 470px;
    background: #040717;
    border-radius: 50px 5px;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    margin-top: 70px;
}
.login_form_container::before{
    
    position: absolute;
    width: 170%;
    height: 170%;
    content: '';
    background-image: conic-gradient(transparent, transparent, transparent, #ee00ff);
    animation: rotate_border 6s linear infinite;

}
.login_form_container::after{
    
    position: absolute;
    width: 170%;
    height: 170%;
    content: '';
    background-image: conic-gradient(transparent, transparent, transparent, #00ccff);
    animation: rotate_border 6s linear infinite;
    animation-delay: -3s;
}

.login_form{
    position: absolute;
    content: '';
    background-color: #0c1022;
    border-radius: 50px 5px;
    inset: 5px;
    padding: 50px 40px;
    z-index: 10;
    color: #00ccff;

} 
.login_form div{
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
} 
.login_form div p{
font-size: 30px;
    font-weight: 600;
    text-align: center;
} 
h1{
    font-size: 80px;
    font-weight: 600;
    text-align: center;
}

</style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>  
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script> 

<!-- This cdn is for sweet alert -->
<script src=
"https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.0/sweetalert.min.js">
  </script>
  
  <script src="https://common.olemiss.edu/_js/sweet-alert/sweet-alert.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://common.olemiss.edu/_js/sweet-alert/sweet-alert.css">
</head>

<body>

	<%
	if (request.getAttribute("success") != null) {
		out.print("<script>swal('Congrates!', 'Password reset Successfully', 'success')</script>");
	}
	%>
	<div class="login_form_container">
      <div class="login_form">
        <h1>404</h1>
        <div>
	        <p>Something went wrong!</p>
	        <p>Please try again! </p>
	        <p>OR </p>
	        <p>Enable your browser cookies</p>
        </div>
      </div>
      
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
  <script type = "text/javascript" >  
  
  $(".input_text").focus(function(){
	    $(this).prev('.fa').addclass('glowIcon')
	})
	$(".input_text").focusout(function(){
	    $(this).prev('.fa').removeclass('glowIcon')
	})
  
  //back prevent
    function preventBack() { window.history.forward(); }  
    setTimeout("preventBack()", 0);  
    window.onunload = function () { null };  
</script>
</body>
    
</html>