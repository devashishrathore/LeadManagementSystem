package in.pandit.helper;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import in.pandit.model.Company;
import in.pandit.model.Lead;
import in.pandit.model.User;

public class CookiesHelper {
	public static void setCookies(Object obj,HttpServletResponse response,String cookieName,int time) throws UnsupportedEncodingException{
        Gson gson = new Gson();
        String objJson = gson.toJson(obj);
        String encodedStudentJson = URLEncoder.encode(objJson, "UTF-8");
        Cookie objCookie = new Cookie(cookieName, encodedStudentJson);
        objCookie.setMaxAge(time);
        response.addCookie(objCookie);
    }
	public static void setCookies(Object obj,HttpServletResponse response,String cookieName) throws UnsupportedEncodingException{
		Gson gson = new Gson();
		String objJson = gson.toJson(obj);
		String encodedStudentJson = URLEncoder.encode(objJson, "UTF-8");
		Cookie objCookie = new Cookie(cookieName, encodedStudentJson);
		response.addCookie(objCookie);
	}
    
    public static User getUserCookies(HttpServletRequest request,String cookieName) throws UnsupportedEncodingException{
        User obj = new User();
        Cookie[] cookies = request.getCookies();
        Gson gson = new Gson();
        
        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if(cookieName.equals(cookie.getName())) {
                    String encodedObjJson = cookie.getValue();
                    String decodedObjJson = URLDecoder.decode(encodedObjJson, "UTF-8");
                    obj = gson.fromJson(decodedObjJson, User.class);
                    break;
                }
            }
        }
        return obj;
    }
    public static Lead getLeadCookies(HttpServletRequest request,String cookieName) throws UnsupportedEncodingException{
    	Lead obj = new Lead();
    	Cookie[] cookies = request.getCookies();
    	Gson gson = new Gson();
    	
    	if(cookies != null) {
    		for(Cookie cookie : cookies) {
    			if(cookieName.equals(cookie.getName())) {
    				String encodedObjJson = cookie.getValue();
    				String decodedObjJson = URLDecoder.decode(encodedObjJson, "UTF-8");
    				obj = gson.fromJson(decodedObjJson, Lead.class);
    				break;
    			}
    		}
    	}
    	return obj;
    }
    public static Company getCompanyCookies(HttpServletRequest request,String cookieName) throws UnsupportedEncodingException{
    	Company obj = new Company();
    	Cookie[] cookies = request.getCookies();
    	Gson gson = new Gson();
    	
    	if(cookies != null) {
    		for(Cookie cookie : cookies) {
    			if(cookieName.equals(cookie.getName())) {
    				String encodedObjJson = cookie.getValue();
    				String decodedObjJson = URLDecoder.decode(encodedObjJson, "UTF-8");
    				obj = gson.fromJson(decodedObjJson, Company.class);
    				break;
    			}
    		}
    	}
    	return obj;
    }
    
    public static void setNormalCookies(String cookieName , String content,HttpServletResponse response) throws UnsupportedEncodingException{
      String encodedCookieName = URLEncoder.encode(cookieName, StandardCharsets.UTF_8.toString());
      String encodedValue = URLEncoder.encode(content, StandardCharsets.UTF_8.toString());
      Cookie objCookie = new Cookie(encodedCookieName, encodedValue);
      objCookie.setMaxAge(60 * 60 * 24);
      response.addCookie(objCookie);
    }
    
    public static String getNormalCookies(String cookieName ,HttpServletRequest request) throws UnsupportedEncodingException{
        String cookieContent = null;
        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if(cookieName.equals(cookie.getName())) {
                    cookieContent = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.toString());
                    break;
                }
            }
        }
        return cookieContent;
    }
    
    public static boolean deleteCookies(String cookieName,HttpServletRequest request,HttpServletResponse response){
        boolean isLogout = false;
        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if(cookieName.equals(cookie.getName())) {
                    cookie.setMaxAge(0); // Set the cookie's expiration time to 0 (in the past)
                    response.addCookie(cookie); // Add the modified cookie to the response
                    isLogout = true;
                    break; // No need to continue searching for the cookie
                }
            }
        }
        return isLogout;
    }
}
