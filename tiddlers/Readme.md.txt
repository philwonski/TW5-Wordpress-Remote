# What is it? 

1. Technically: A single-page HTML file that can talk to the Wordpress API. 
2. Effectively: 
   * A potential replacement for the Wordpress backend for some publishers/tasks.  
   * A way to use Wordpress as a backend for Tiddlywiki, a frontend SPA with AJAX. 

# Who is it for? 

1. In Development: 
   * People who want to make custom Wordpress backend views/actions. 
   * People who want to integrate Tiddlywiki with a stable backend. 

2. In Practice: 
   * People who find the Wordpress backend slow or confusing, and want to power up backend tasks using the power of Tiddlywiki (think bulk creation/editing of posts). 
   * People who are looking for a way to add signup and user storage to Tiddlywiki. 

![Screenshot](wp_remote_screenshot.jpg)

# Getting Started

From this repository you need only the `remote.html` to get started; but there is an important  prerequisite within Wordpress, as you'll need to follow the steps to install the [JWT Authentication for WP-API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/) first (it's very straightforward).

Once you're done with that, you can just drop the `talk.html` file from the `output/` directory of this repository into whatever directory houses your Wordpress index.php file. Then simply navigate to [yourdomain]/talk.html and login to Wordpress.

Once you log in, a button will pop up under the login form to allow you to "View Posts." 

Note that the reader won't work from your local machine unless you set up CORS support with the WP JWT plugin. Best practice is just to drop the file on your actual domain. 

## Prerequisites 

1. A site running Wordpress and the ability to upload the talk.html file. 
2. The WP API plugin installed and configured as per the instructions. 

## Doing your own thing with it

This tool was created in [Tiddlywiki](https://tiddlywiki.com) (TW5). If you know Tiddlywiki, you can clone this repository and interact with the .tid files directly. You can also run it locally on node: from a shell in this directory, run `tiddlywiki --listen port=8089` to run Tiddlywiki locally (on port 8089) and interact with it in the browser. 

This wiki uses a combination of the following plugins:

1. LOGIN - Jed [@Ooktech](https://github.com/OokTech) created a killer extension of Tiddlywiki called Bob, which adds multi-user functionality to Tiddlywiki (among other things); his Login plugin, [TW5-Login](https://github.com/OokTech/TW5-Login), is a precursor/component of Bob. It's used to send a request to Wordpress for a token, then store the token in cookies and localstorage. I made only a slight modification in handling the token. 

1. GET WP DATA - Paulin in [this thread](https://groups.google.com/g/tiddlywiki/c/E_X3KUHOvEk/m/ucL23ju5AAAJ) shared his elegant AJAX script to fetch some data with a GET request and create a tiddler out of it. This is modified only slightly so it will fetch json instead of markdown. *NOTE* when TW reads the data from the GET request, it takes the image url from `jetpack_featured_media_url`, which won't be present unless the site is using Wordpress's Jetpack plugin. 

2. SEND WP DATA - Jed [@Ooktech](https://github.com/OokTech) strikes again with his straightforward POST request from tiddlywiki in [TW5-SubmitForm](https://github.com/OokTech/TW5-SubmitForm). I have modified it slightly for posting json payloads instead of url params. So far I have only updated "published date" of a post for scheduling, and I haven't built an interface for this yet... ultimately I would like to be able to do everything the API can accommodate, especially inserting things into Gutenberg blocks (it's easy to send text and create a Post, but modifying blocks is another story). 

3. MANIPULATE DATA - @joshuafontany opens up a world of possibilities for Tiddlywiki users with his [jsonmangler](https://github.com/joshuafontany/TW5-JsonMangler) plugin, which allows us to handle nested json in Tiddlywiki (TW5 only supports flat json without this plugin, which limits AJAX functionality). 

# To-Do

1. Clean up the basics for reading data 
   * Improve "Posts" view
   * Add non-Jetpack image fields

2. Add some write functionality
   * Make published date functionality visible on "Posts" view
   * Add other basic write capabilities
   * Add routes (fields) to Wordpress Posts for writing data 
   * Create ability to work directly with content in Gutenberg blocks 

3. Demonstrate "headless Wordpress" as a backend for a frontend Tiddlywiki app.  