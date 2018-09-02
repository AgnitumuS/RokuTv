function playvideo(video as Object)
    'print  m.isSubscribed 
    cdnId = ""
    if video.jwp_video_url = true  then 
        cdnId = video.jwp_video_url
    else
        videoDetail  = CallApi("video", video.videoId)
        cdnId = videoDetail.responseData.jwp_video_url
        'cdnId = 
    end if
    
    'videourl = videoCdnId(cdnId)
    videourl = cdnId
    'print videourl    
   'videourl = "http://api.ooyala.com/syndication/redirect?embed_code=B0bDYxbzphtJoCEk5a4ua9e9p4f7ddBB&type=mp4&id=cc367881-0f6e-4c94-9aeb-4011ed1f3af3"
    'Loading ads prior to video play 

   isSubscribed = getSubSetting()
    if (isSubscribed =  "FAILED")
       preVideoAd(videourl,cdnId, video.title)
   else
        PlayDirectVideo(videourl,cdnId, video.title)
   end if   
End function

function PlayDirectVideo ( videourl as string ,  VideoId as string, VideoTitle as string)
               ' print videourl
     'Playing Videos
                        port = CreateObject("roMessagePort")
                        screen = CreateObject("roVideoScreen")
                        screen.SetMessagePort(port)
                        
                        'TC video.Stream = { url: videourl}
                        
                       metadata = {
                            Stream : { url: videourl }
                            StreamFormat : "hls"
                            'StreamFormat : "mp4"
                            Title : VideoTitle
                        }
                        
                        screen.SetPositionNotificationPeriod(30)
                        screen.SetContent(metadata)
                        screen.Show()
                        while true
                           msg = wait(0, port)
                           
                           if type(msg) = "roVideoScreenEvent" then
                            if msg.isScreenClosed()
										'return -1
                                    exit while
                                else if msg.isRequestFailed()
                                    'print "Video request failure: "; msg.GetIndex(); " " msg.GetData() 
                                else if msg.isStatusMessage()
                                    'print "Video status: "; msg.GetIndex(); " " msg.GetData() 
                                else if msg.isButtonPressed()
                                    'print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
                                else if msg.isPlaybackPosition() then
                                    nowpos = msg.GetIndex()
                                    'RegWrite(episode.ContentId, nowpos.toStr())
                                else
                                    'print "Unexpected event type: "; msg.GetType(); " " msg.GetMessage()
                                end if
                           else
                              'print  "unexpected msg type"+  type(msg)
                           end if        
                           
                        end while
End Function



function  preVideoAd( videourl as string ,  VideoId as string, VideoTitle as string)
     'print "Play Ad video"
    ' Create canvas for ad playback
    canvas = CreateObject("roImageCanvas")
    canvas.SetMessagePort(CreateObject("roMessagePort"))
    canvas.SetLayer(1, {color: "#00000000", CompositionMode: "Source"})
    canvas.show()

    ' Set up required AdManager init parameters
    initParameters = {
        LR_PUBLISHER_ID: 65715        
        LR_AUTOPLAY:1 
        LR_TITLE: VideoTitle
        LR_VIDEO_ID: VideoId
        'LR_DURATION:30
        'LR_PARTNERS:761489
        'LR_DISABLE_UDS:1
        messagePort: canvas.GetMessagePort()
        destinationRect: canvas.GetCanvasRect()
    }
    
    adManagerController = LiveRailAdManagerController()
    ' Play preroll ad and get result
    adResult = adManagerController.showAd(initParameters)
    
       if (NOT adResult.backButtonPressed)
                       'Playing Videos
                        port = CreateObject("roMessagePort")
                        screen = CreateObject("roVideoScreen")
                        screen.SetMessagePort(port)                        
                        'TC video.Stream = { url: videourl}
                        metadata = {
                            Stream : { url: videourl }
                            StreamFormat : "hls"
                            ' StreamFormat : "mp4"
                             Title : VideoTitle
                        }
                        
                        screen.SetPositionNotificationPeriod(30)
                        screen.SetContent(metadata)
                        screen.Show()
                        while true
                           msg = wait(0, port)
                           
                           if type(msg) = "roVideoScreenEvent" then
                            if msg.isScreenClosed()
										'return -1
                                    exit while
                                else if msg.isRequestFailed()
                                    'print "Video request failure: "; msg.GetIndex(); " " msg.GetData() 
                                else if msg.isStatusMessage()
                                    'print "Video status: "; msg.GetIndex(); " " msg.GetData() 
                                else if msg.isButtonPressed()
                                    'print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
                                else if msg.isPlaybackPosition() then
                                    nowpos = msg.GetIndex()
                                    'RegWrite(episode.ContentId, nowpos.toStr())
                                else
                                    'print "Unexpected event type: "; msg.GetType(); " " msg.GetMessage()
                                end if
                           else
                              'print  "unexpected msg type"+  type(msg)
                           end if        
                           
                        end while
       end if     
    
end function 
