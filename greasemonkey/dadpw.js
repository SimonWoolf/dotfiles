// ==UserScript==
// @name        New script 
// @namespace   Violentmonkey Scripts
// @match       https://accounts.google.com/*
// @grant       none
// @version     1.0
// @author      -
// @description 14/11/2022, 13:52:06
// ==/UserScript==
for(let el of document.querySelectorAll('span')) {
  if(el.innerHTML === "Forgot password?") {
    el.outerHTML = "<a href='https://simonwoolf.net/dad_password.html'>Forgot password?</a>";
  }
} 

