Function SeriesScreen(seriesId as Integer)
     REM Setting theme
     SetHomeTheme()
     
     REM Function to set screen type
     poster = setSeriesScreenType()
     poster.SetupLists(1)
     poster.SetListNames(["Videos"])
     poster.SetDescriptionVisible(False)
     
     videosList = getAllVideos(seriesId)
     poster.SetContentList(0, videosList)
     poster.SetLoadingPoster("pkg:/locale/default/images/Overhang_Slice_HD.png", "pkg:/locale/default/images/Overhang_Slice_HD.png")
     poster.Show() 
 
     While True
         msg = wait(0, poster.GetMessagePort())
         If msg.isScreenClosed() Then
             'return -1
			 exit while
         Else If msg.isListItemSelected()
              videoDetailArray = videosList[msg.GetData()]
              videosList[msg.GetData()].process(videoDetailArray)
         End If
     End While
End Function

Function getAllVideos(seriesId as Integer)
    videosList = CreateObject("roArray", 1, True)
    'print "Called from 1";
    videos = getAllVideosOfSpecificSeries(seriesId)
    for each video in videos.responseData.episodeList
		video.watchList = "NO"
        videosList.push(createPosterforVideo(video))
    End for
    return videosList
End Function


Function setSeriesScreenType()
     port = CreateObject("roMessagePort")
     poster = CreateObject("roGridScreen")
     poster.SetBreadcrumbText("", "Series")
     poster.SetMessagePort(port) 
     poster.SetGridStyle("two-row-flat-landscape-custom")
     return poster
End Function 