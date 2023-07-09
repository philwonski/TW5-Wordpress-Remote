/*\
/*\
title: philwonski/TW5-Wordpress-Remote/wp.js
type: application/javascript
module-type: widget
wpremote widget
\*/

// wpremote widget
// use like <$wpremote wpaction="getposts"/>

(function() {

  /*jslint node: true, browser: true */
  /*global $tw: false */
  "use strict";
  
  var Widget = require("$:/core/modules/widgets/widget.js").widget;

  /* Import the Wordpress class with all the cool methods */
  const Wordpress = require("$:/plugins/philwonski/TW5-Wordpress-Remote/classWordpress.js");

  var MyWidget = function(parseTreeNode, options) {
      this.initialise(parseTreeNode, options);
  };
  
  /*
  Inherit from the base widget class
  */
  MyWidget.prototype = new Widget();
  
  /*
  Render this widget into the DOM
  */
  MyWidget.prototype.render = async function(parent, nextSibling) {

      this.parentDomNode = parent;
      this.computeAttributes();
      // var reply = this.execute();
      var reply = await this.execute();
      var textNode = this.document.createTextNode(reply);
      parent.insertBefore(textNode, nextSibling);
      this.domNodes.push(textNode);
  };

  /*
  Do execution of logic
  */

  MyWidget.prototype.execute = async function() { 
      // get the command the user provided in the frontend widget invocation
      this.COMMAND = this.getAttribute("wpaction");

      // now collect params for the various commands

      if (this.COMMAND == "getposts") {
        // command="hangover" params: day1, day2
        this.wpaction = this.getAttribute("wpaction");
        this.wpsite = this.getAttribute("wpsite");
        var instructions = `testing ${this.COMMAND} on ${this.wpsite}...`;
      } 
      
        else if (this.COMMAND == "post-summary") {
        // command="hangover" params: day1, day2
        this.wpaction = this.getAttribute("wpaction");
        this.post = this.getAttribute("post");
        this.aicreds = this.getAttribute("creds");
        var instructions = `testing ${this.COMMAND} ...`;
      }
      
      return instructions;
};
  
  /*
  Refresh if the attribute value changed since render
  */
  MyWidget.prototype.refresh = function(changedTiddlers) {
      // Find which attributes have changed
      var changedAttributes = this.computeAttributes();
      if (changedAttributes.message) {
          this.refreshSelf();
          return true;
      } else {
          return false;
      }
  };

  MyWidget.prototype.invokeAction = async function(triggeringWidget,event) {
      var COMMAND = this.COMMAND;

     if (COMMAND == "getposts") {
      // ******************************************************************************** //
      //  EXAMPLE- WPAPI: get posts
      // ******************************************************************************** //

      //var ACTION = COMMAND;
      var WPsite = this.wpsite;
      // var CREDS = this.wiki.getTiddler('wp_creds');

      // <$wpremote wpaction="getposts"/>

      var wp = new Wordpress();
      await wp.runFetchWpPosts(WPsite);
      var msg = "got posts, check for new tiddlers with post id in title";

    return console.log(msg);
  
  }     else if (COMMAND == "post-summary") {
    // ******************************************************************************** //
    //  EXAMPLE- OPENAI: summarize a post you pulled from WP
    // ******************************************************************************** //

     
      var post = this.post;
      var aicreds = this.aicreds;

      var wp = new Wordpress();
      await wp.getAIsummary(aicreds, post);
      var msg = "sent post, check for summary in aisummary field of the post";

      return console.log(msg);
}
  
  
  else if (COMMAND == "test" || COMMAND == "hello" || COMMAND == undefined || COMMAND == "") {
    var reply = "Hello, World! The plugin is installed.";
    return reply;
  } 
  
  };
  
  
  exports.wpremote = MyWidget;
  
  })();