Function searchResult(videosList as Object)
     REM Setting theme
     SetTheme()
     
     REM Function to set screen type
     poster = setSearchResultScreenType()
     poster.SetupLists(1)
     poster.SetListNames(["Videos"])
     poster.SetDescriptionVisible(true)
     
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

Function getAllFilteredVideosForSearchResult(searchKeyword as String)
    REM below two lines to replace the space by %20 to prevent url error
    r = CreateObject("roRegex", " ", "i")
    searchKeyword = r.ReplaceAll(searchKeyword, "%20")

    videosList = CreateObject("roArray", 1, True)
    videos = geFilteredtVideoAccordingToSearchKeyword(searchKeyword)
    for each video in videos.responseData
		 video.watchList = "NO"
        videosList.push(createPosterforVideo(video))
    End for
    return videosList
End Function


Function setSearchResultScreenType()
     port = CreateObject("roMessagePort")
     poster = CreateObject("roGridScreen")
     poster.SetBreadcrumbText("", "Search Result")
     poster.SetMessagePort(port) 
     poster.SetGridStyle("two-row-flat-landscape-custom")
     return poster
End Function 