Function searchScreen()
    setTheme()
    
    displayHistory = True 
    result  = CreateObject("roAssociativeArray")
    result.history = CreateObject("roArray", 1, true)
    result.index = CreateObject("roArray", 1, true)
    'history.push("Intekhab alam")
    'prepopulate the search history with sample results
    
    port = CreateObject("roMessagePort")
    screen = CreateObject("roSearchScreen")
    screen.SetMessagePort(port) 
    if displayHistory
        screen.SetSearchTermHeaderText("Search Result")
        screen.SetSearchButtonText("search")
        screen.SetClearButtonText("clear history")
        screen.SetClearButtonEnabled(true) 'defaults to true
        screen.SetSearchTerms(result.history)
    else
        screen.SetSearchTermHeaderText("Search Result")
        screen.SetSearchButtonText("search")
        screen.SetClearButtonEnabled(false)
    endif 
    screen.SetBreadcrumbText("", "Search")
    screen.Show() 
    'print "Waiting for a message from the screen..."
    ' search screen main event loop
    done = false
    while done = false
        msg = wait(0, screen.GetMessagePort()) 
        if type(msg) = "roSearchScreenEvent"
            if msg.isScreenClosed()
                'print "screen closed"
                done = true
                'return -1
				exit while
            else if msg.isCleared()
                'print "search terms cleared"
                result.history.Clear()
            else if msg.isPartialResult()
                                   
            else if msg.isFullResult()
                'print "SEARCHED"
                if msg.GetMessage()<>"" then
                    searchKeyword = msg.GetMessage()
                    REM Function to decide weither song has to play(If single song) or songs have to list(if multiple songs)
                    eitherPlayOrListTheSong(searchKeyword) 
                else
                    screen.SetEmptySearchTermsText("Type Something To Search")
                end if
            Else if msg.isScreenClosed()
                 'Return -1
				 exit while
            else
                'print "Unknown event: "; msg.GetType(); " msg: ";msg.GetMessage()
            endif
        endif
    endwhile 
    'print "Exiting..."
    
end Function


REM Function to decide weither song has to play(If single song) or songs have to list(if multiple songs)
Function eitherPlayOrListTheSong(searchKeyword as String)
        if searchKeyword  <> "" then
            videosList = getAllFilteredVideosForSearchResult(searchKeyword)
            'if videosList.Count() = 1 then
                REM Function to play the video if there is one video only
				'playvideo(videosList[0], m.isSubscribed)
            'else if videosList.Count() > 1
            IF videosList.Count() = 0
                 showErrorDialog("No Result","Nothing matches your search Criteria")
            Else 
                searchResult(videosList) 
            End If
            
               
            'else 
             '   screen.SetEmptySearchTermsText("No Ressult Found") 
            'End If 
        End if  
End Function