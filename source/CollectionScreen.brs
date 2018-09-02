Function CollectionScreen(collectionId as Integer)  
    SetHomeTheme()
    port = CreateObject("roMessagePort")
    gridScreen = CreateObject("roGridScreen")
    gridScreen.SetMessagePort(port)  
    gridScreen.SetGridStyle("two-row-flat-landscape-custom")
    gridScreen.SetLoadingPoster("pkg:/locale/default/images/Overhang_Slice_HD.png", "pkg:/locale/default/images/Overhang_Slice_HD.png")
    CreateCollectionScreen(gridScreen, collectionId)
End Function


Function CreateCollectionScreen(gridScreen as object, collectionId as Integer )
    'TC 
    gridScreen.SetupLists(3)
    gridScreen.SetupLists(2)
    'TC 
    gridScreen.SetListNames(["Search", "Series", "Videos"])
    gridScreen.SetListNames(["Search", "Series"])
    'gridScreen.SetDisplayMode(0, False)
    gridScreen.SetDescriptionVisible(False)
    'gridScreen.SetFocusedListItem(1, 0)
    gridScreen.SetBreadcrumbText("", "Collections")
     
    list = getSearchSubscribeSigninCat()
    seriesAndVideosPoster = CollectionDetails(collectionId)
    gridScreen.SetContentList(0, list)
    gridScreen.SetContentList(1, seriesAndVideosPoster.series)
    'gridScreen.SetContentList(2, seriesAndVideosPoster.episode)
    gridScreen.Show()
     
    while true
         msg = wait(0, gridScreen.GetMessagePort())
         if type(msg) = "roGridScreenEvent" then
             if msg.isScreenClosed() then
                 'return -1
				 exit while
             else if msg.isListItemFocused()
                 'print "Focused msg: ";msg.GetMessage();"row: ";msg.GetIndex();
                 'print " col: ";msg.GetData()
             else if msg.isListItemSelected() then
                 if (msg.GetIndex()=0)
                     if (msg.GetData()=0)
                        list[msg.GetData()].process()
                     end if
                     if (msg.GetData()=1)
                        
                     end if
                     if (msg.GetData()=2)
                        list[msg.GetData()].process()
                     end if
                 end if
                 if (msg.GetIndex()=1)
                     seriesId = seriesAndVideosPoster.series[msg.GetData()].seriesId
                     seriesAndVideosPoster.series[msg.GetData()].process(seriesId)
                 end if
                 if (msg.GetIndex()=2)
                       'print  seriesAndVideosPoster.episode[msg.GetData()]
                       videoDetailArray = seriesAndVideosPoster.episode[msg.GetData()]
                       seriesAndVideosPoster.episode[msg.GetData()].process(videoDetailArray)
                 end if
             endif
         endif            
     end while
End Function
