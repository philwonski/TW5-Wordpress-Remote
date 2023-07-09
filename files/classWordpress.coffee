WPAPI = require('./helper-wpapi.js')

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
    
    getAIsummary: (creds_tid, msg_tid) =>
        
        # grab the api key from the creds tiddler
        creds_obj = $tw.wiki.getTiddler(creds_tid)
        apikey = creds_obj.fields.apikey
        # console.log(apikey)
        
        # grab the message from the msg tiddler
        # prepare the payload like OpenAI wants it
        msg_obj = $tw.wiki.getTiddler(msg_tid)
        txt = msg_obj.fields.text
        txt_obj = JSON.parse(txt)
        msg = txt_obj.content.rendered
        msg_payload = {}
        msg_payload["role"] = "user"
        msg_payload["content"] = msg

        #sysmsg = msg_obj.fields.sysmsg
        sysmsg = "your job is to summarize an article as concisely as possible. Try to use 2-4 bullet points if possible."
        sysmsg_payload = {}
        sysmsg_payload["role"] = "system"
        sysmsg_payload["content"] = sysmsg

        #model = msg_obj.fields.model
        model = "gpt-4-0613"
        # msg = "hello there"
        url = "https://api.openai.com/v1/chat/completions"

        msgs = [sysmsg_payload, msg_payload]

        pl = {}
        pl.model = model
        pl.messages = msgs
        payload = JSON.stringify(pl)
        auth = "Bearer " + apikey

        # now send the request to OpenAI
        try
            # per HelloJson guidelines, this request should really be via a promise from a helper file
            # but i had the below handy from @Ooktech so I'm using it for now
            formRequest = new XMLHttpRequest
            formRequest.open 'POST', url, true
            formRequest.setRequestHeader 'content-type', 'application/json'
            formRequest.setRequestHeader 'Authorization', auth
            formRequest.send payload

            formRequest.onreadystatechange = ->
                if formRequest.readyState == 4 && formRequest.status == 200
                    response = JSON.parse(formRequest.responseText)
                    console.dir(response)
                    reply = response.choices[0].message.content
                    $tw.wiki.setText msg_tid, "aisummary", "", reply
                    return reply
                else
                    $tw.wiki.setText msg_tid, "aisummary", "", "it didn\'t work"
                    return "error getting AI reply (maybe from remote, check nw console) in getAIreply method"
        catch e
            console.log(e)
            return "error getting AI reply in getAIreply method"

    
    
    runMsg: =>
        msg = "hello there"
        return msg


module.exports = Wordpress