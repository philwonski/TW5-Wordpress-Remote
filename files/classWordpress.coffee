WPAPI = require('./wpapi.js')

class Wordpress
    constructor: (@w = {}) ->

    runName: =>
        @w
    
    twMakeTid: (tid, text) =>
        console.log("running runMakeTid method");
        try  
            title = tid
            body = text
            return $tw.wiki.addTiddler({
                    title: title,
                    text: body,
                    tags: "test"
                  });
        catch e
            console.log(e)
            return "error making tiddler in runMakeTid method"
    
    runFetchWpPosts: (wpsite) =>

        endpoint = "https://" + wpsite + "/wp-json/"
        namespace = 'wp/v2'
        postRoute = '/posts/(?P<id>)'
        site = new WPAPI({endpoint: endpoint})
        site.post = site.registerRoute(namespace, postRoute)

        try
            posts = await site.post().perPage( 5 ).page( 1 ).get()
            # console.log(JSON.stringify(posts))
            importer = (x) =>
                wptitle = "import-" + x.id
                wplink = x.link
                wptext = JSON.stringify(x)
                title = x.title.rendered
                body = x.content.rendered
                return $tw.wiki.addTiddler({
                    title: wptitle,
                    text: wptext,
                    type: "application/json",
                    tags: "wpPost",
                    wplink: wplink
                  })
            
            for post in posts
                await importer(post)

            return "got posts"
        catch e
            console.log(e)
            return "error fetching wp posts in runFetchWpPosts method"
    
    runMsg: =>
        msg = "hello there"
        return msg


module.exports = Wordpress