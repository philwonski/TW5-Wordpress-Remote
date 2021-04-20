/*\
title: $:/sandbox/myjax.js
type: application/javascript
module-type: macro


<<getDataFromUrl "tiddlername" "url">>
Example to get data from wikipedia: <<getDataFromUrl "Eureka" "https://en.wikipedia.org/wiki/Eureka_(word)">>


\*/

(function(){


/*jslint node: true, browser: true */
/*global $tw: false */
"use strict";

exports.name = "getJSONFromUrl";


exports.params = [ {name: "tiddlername"},{name: "url"}];



/*
Run the macro
*/
exports.run = function(tiddlername,url) {

 var url = url || "None";

 var tiddlername = tiddlername || "None";

 var tok = localStorage.getItem('ws-token');

 var tokp = JSON.parse(tok);

 var mytok = tokp.token;

  //console.log("**** url > "+url);
  //console.log("**** tiddler > "+tiddlername);
  
  //thanks to http://heckyesmarkdown.com/ for the api to get markdown  
  $tw.utils.httpRequest({url: ""+url, headers: {'Authorization': 'Bearer '+mytok}, callback: function (error,data){
    if (error){
    console.log("ERROR:"+error);
    }
    $tw.wiki.addTiddler({title:tiddlername, text:data, type: "application/json"});
    console.log(data);
  }})
  return "[["+tiddlername+"]]";
};


})();