// ==UserScript==
// @name        New script
// @namespace   Violentmonkey Scripts
// @match       https://accounts.google.com/
// @grant       none
// @version     1.0
// @author      -
// @description 13/11/2022, 18:57:32
// ==/UserScript==
for(let el of document.getElementsByTagName("span")) {
  if(el.innerHTML === "Forgot password?") {
    el.parentElement.outerHTML = "<a href='http://simonwoolf.net/dad_password.html'>Forgot password?</button>";
  }
}
