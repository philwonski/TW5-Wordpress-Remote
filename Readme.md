# TW5-Wordpress-Remote

WP-Remote is a tool for communicating with the Wordpress's built-in REST API -- without requiring any special plugins on the Wordpress site. Demo [here](https://philwonski.github.io/TW5-Wordpress-Remote/#test-wpapi).

Based on [TiddlyWiki](https://tiddlywiki.com), you can now use the power of TiddlyWiki's *WikiText* syntax to talk to a Wordpress site. 

```
<$wpremote wpaction="getposts" wpsite="mydigitalmark.com">
```

Handy! 

# Why?

Sometimes the Wordpress backend can be cumbersome (or even inaccessible). Come to think of it, sometimes the Wordpress *frontend* of a site can be pretty cumbersome, too. 

This plugin allows you to quickly use and build new interfaces for consuming/modifying Wordpress content, working with Wordpress sites in a "headless" fashion. The plugin uses the power of TiddlyWiki and WikiText to ingest, modify, and post updates to Wordpress websites. 

> **That's the why:** TiddlyWiki is crazy fast for building custom user interfaces using its WikiText syntax.

In this way, the plugin is just exposing a bunch of Wordpress methods (get posts, create a post, etc) in WikiText when you call on the widget like this `<$wpremote wpaction="YOUR_ACTION">`. 

# How?

Short answer: I wrapped the [WPAPI NPM library](https://www.npmjs.com/package/wpapi) in a TiddlyWiki plugin so you can call its cool methods in your WikiText. 

Longer answer:

Developers are like onions. We have layers.

Or we *like* layers. As in layers of abstraction.

So how this all works is:

- Some very smart people abstracted website management via a big PHP monolith called Wordpress. (abstraction count: 1)
- Some of the same very smart people abstracted the Wordpress database into a REST API. (abstraction count: 2)
- Some other very smart people abstracted the Wordpress REST API into a NodeJS library called WPAPI. (abstraction count: 3)
- Some other very smart people, especially Jeremy Ruston, abstracted UI development into a syntax called WikiText, which runs in a single-page application called TiddlyWiki. (abstraction count: 4)
- I abstracted TiddlyWiki plugin development into an organizational framework called HelloJson. (abstraction count: 5)
- I abstracted the WPAPI library into the HelloJson style, creating the TiddlyWiki plugin you're reading about called TW5-WP-Remote. (abstraction count: 6)
- YOU now get to abstract all the above with your creative wikitext via `<$wpremote>` calls in your Wiki. (abstraction count: 7)

7 layers of abstraction to empower you (and me) to do stuff like this `<$wpremote wpaction="createposts" tidfilter="[tag[toPublish]]" />`.

🤓

# This Repo

This repo uses a CI pipeline borrowed from my opinioned TiddlyWiki plugin development framework called [HelloJson](https://github.com/philwonski/twplugins-hello-json).

HelloJson is mostly about the file structure:

- `wp.js` - the main plugin file that's (almost) straight from the TiddlyWiki plugin boilerplate, with as little logic as possible. It calls on the class file.
  - `files/classWordpress.js` - the class file is where we put all the "business logic" for performing operations via our own custom methods like `getPhilsTop10Posts()`. According the HelloJson style conventions, we try to keep the class file relatively clean by calling helper files when necessary. We also compile the file from a coffeescript parent file, `classWordpress.coffee`.
    - `files/wpapi.js` - is the first helper file for this repo. It's just a minified version of the WPAPI library.

# Setup

*Option 1*

You can check out the [demo](https://philwonski.github.io/TW5-Wordpress-Remote/#test-wpapi) and, via the Control Panel, [drag and drop this plugin](https://tiddlywiki.com/#Manually%20installing%20a%20plugin) right into your wiki. 

Now you've got the plugin in your wiki and can mess with the wikitext, or even overwrite the plugin files with your own customizations (requires restart + refresh of your Wiki to see the changes).

*Option 2*

I set up my dev environment exactly like the instructions here: 

[https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub](https://tiddlywiki.com/dev/#Developing%20plugins%20using%20Node.js%20and%20GitHub)

It may seem like a bunch of steps, but the build process is very logical once you get the hang of it. It can be boiled down to this:

1. Make a folder on your computer called TWdev (or whatever you want). This is where you will keep all your plugins that you work on.

2. Inside the new directory, install a local copy of TW5 with `git clone https://github.com/Jermolene/TiddlyWiki5.git TW5`.

3. Now you can see the TW5 directory has two important folders: `/editions` and `/plugins`. All we are doing is:
    1. Adding our own plugin code under plugins.
    2. Picking an edition, like `TW5/editions/empty`, and adding a quick reference to our plugin in the `tiddlywiki.info` file.
    3. Running a single command *in the TW5 folder* to build that particular edition with our plugin included, like `node ./tiddlywiki.js editions/empty --build index`... this will create a static html version of the wiki you can view and share. Find the static file in the the `output` folder under the edition you just built.

So the top of my file `TWdev/TW5/editions/empty/tiddlywiki.info` now looks like this:

```
{
	"description": "Empty edition",
	"plugins": [
		"philwonski/TW5-Wordpress-Remote"
	],

```

And I can generate a static html version of the wiki, with my plugin included, by running this command in the TW5 folder: `node ./tiddlywiki.js editions/empty --build index` and then opening the file `...TWdev/TW5/editions/empty/output/index.html#test-wpapi` in my browser.

If you modify the class file, remember to compile the updated javascript file with `coffee -c classWordpress.coffee` from the /files folder.

# Usage

The plugin adds a new widget called `<$wpremote>` that you can use in your wikitext. As of my first commits to the "reboot" version of this plugin in 2023, I have hardcoded a method to get 5 posts from page 1 of any site running the Wordpress like this:

```
<$wpremote wpaction="getposts" wpsite="mydigitalmark.com">
```

I have found this is actually a great way to browse different sites and see a consolidated view of their latest posts, almost like an RSS feed. 

# Examples

Look out for more methods I'll be adding here soon, including the ability to accept Wordpress credentials and perform actions like creating posts, updating posts, and deleting posts. Wordpress and its REST API now have this functionality built-in: all you have to do is pull up an admin in the Wordpress backend and enable an "Application Password" for them. 


