# Stream Config

This is the setup that I use to offload encoding to a second PC without using a capture card. 


# Intro


I've had lots of problems trying to stream with a capture card with a monitor that has a higher refresh rate than my capture card. I don't want to deal with the performance hit of doing cpu encoding while gaming, and I don't want the stream to look like garbage by using GPU encoding. But without the capture card we have to find a way to get the stream from one PC to another.


Enter NGINX + RTMP.


We can use an nginx server to listen for rtmp streams. Take the stream and use ffmpeg to compress it on the fly, and forward it off to our prefered streaming service, which is twitch for us.


The initial problem of reducing overhead on the gaming pc still exists though. The reason we didn't just use gpu encoding in the first place is how bad it looks at a given bitrate compared to cpu encoding. I would just send 25Mbps w/ gpu encoding to twitch and call it a day, but they cap you at 6Mbps. Our server does not have that limitation. Plus local network bandwidth is effectively limitless.


So, on the gaming PC use GPU encoding at the highest possible bitrate at medium/balanced preset. I'm using quicksync, but the AMD/Nvidia options may be different. Crank it as high as you can before performance drops. Pipe that to your server running nginx, let the server cpu encode it as best it can (at a much lower bitrate) and send it off to twitch. It's their problem now.


If you want to get fancy with it you could even use the ffmpeg step to do post processing, or overlays or whatever. I don't know. Get creative.
