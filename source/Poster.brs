REM Function to Create Poster for Collection
function createPosterforCollection(Item as object) as Object
        REM CODE TO BE DONE BY INTEKAB
        o = CreateObject("roAssociativeArray")
        o.collectionId = Item.collectionId
        o.title = Item.title
        o.Description = Item.shortDescription
        o.Rating = 3.5
        o.HDPosterUrl = Item.imageUrl
        o.SDPosterUrl = Item.imageUrl
        o.image_name = Item.image_name
        o.path = Item.path
        o.seriesCount = Item.seriesCount
        o.episodesCount = Item.episodesCount
        o.ShortDescriptionLine1 = Item.title    
        o.process = CollectionScreen  'Function to be called when any collection is selected
        return o             
End Function 


REM Function to Create Poster for Series
Function createPosterforSeries(Item as object) as Object
    'print item.imageUrl
    o = CreateObject("roAssociativeArray")
    o.seriesId = Item.seriesId
    o.title = Item.title
    o.Description = Item.shortDescription
    o.HDPosterUrl = Item.imageUrl
    o.SDPosterUrl = Item.imageUrl
    o.image_name = Item.image_name
    o.path = Item.path
    o.seriesCount = Item.seriesCount
    o.episodesCount = Item.episodesCount
    o.ShortDescriptionLine1 = Item.title    
    o.process = SeriesScreen
    return o 
End Function


REM Function to Create Poster for Videos
Function createPosterforVideo(Item as object) as Object
        REM CODE TO BE DONE BY INTEKAB
        o = CreateObject("roAssociativeArray")
        o.videoId = Item.videoId
        o.title = Item.title
        o.Description = Item.shortDescription
        o.HDPosterUrl = Item.rokuImageUrl 'imageUrl
        o.SDPosterUrl = Item.rokuImageUrl 'imageUrl
        o.videoName = Item.videoName
        o.path = Item.path
        o.watchList = Item.watchlist
        'o.seriesCount = video.seriesCount
        ' o.episodesCount = video.episodesCount
        o.ShortDescriptionLine1 = Item.title  
        'o.ShortDescriptionLine2 = Item.videoName   
       ' o.process = playvideo
        o.process = slideDetailScreen
        return o
End Function


function getSearchSubscribeSigninCat()
    list = CreateObject("roArray", 1, true)
    
       hdposter = "pkg://locale/default/images/LoginHD.jpg"
        sdposter = "pkg://locale/default/images/LoginSD.jpg"
        titleText = "Login"
        DescText = "Enter your username and password to login. If you are a subscribed user you won't see ads."
         item1 =  CreateListItem("", "", "",hdposter, hdposter)
         item1.title = titleText
         item1.Description = DescText
         item1.process = LoginScreen 
     
        hdposter = "pkg://locale/default/images/LogoutHD.jpg"
        sdposter = "pkg://locale/default/images/LogoutSD.jpg"
        titleText = "Logout"
        DescText = "Click here to logout from application"
         item2 =  CreateListItem("", "", "",hdposter, hdposter)
        item2.title = titleText
        item2.Description = DescText
        item2.process = LogoutScreen
        
        
        hdposter = "pkg://locale/default/images/WatchListHD.jpg"
        sdposter = "pkg://locale/default/images/WatchListSD.jpg"
        titleText = "Watch List"
        DescText = "Click here to visit watch list"
        watchLi   =  CreateListItem("", "", "",hdposter, hdposter)
        watchLi.title = titleText
        watchLi.Description = DescText
        watchLi.process = watchListScreen
        
        hdposter = "pkg://locale/default/images/subscribeHD.jpg"
        sdposter = "pkg://locale/default/images/subscribeHD.jpg"
        SubItem =  CreateListItem("", "", "",hdposter, sdposter)
        SubItem.process =  subscribeScreen
        SubItem.title = "Subscribe"
        SubItem.Description = "Subscribe to watch ad free videos."
        
        
        'subscribe.Description = "For a low monthly fee, subscribers enjoy ad-free viewing of all that XiveTV has to offer!"
        
        hdposter = "pkg://locale/default/images/SignUpHD.jpg"
        sdposter = "pkg://locale/default/images/SignUpSD.jpg"
        titleText = "Sign Up"
        DescText = "Click here to visit watchlist"
        SingUP   =  CreateListItem("", "", "",hdposter, hdposter)
        SingUP.title = titleText
        SingUP.Description = "Create a free account to access more features of XiveTV! Rate our shows, create personalized watch lists, comment on videos and more!"
        SingUP.process = EnterName
        
        
    userDetail  = getAuthSetting()
    
    if userDetail = "SUCCESS"
        isSubscribed = true
    else
        isSubscribed = false
    end if 
               
    if isSubscribed = false
        list.push(item1)
        list.push(SingUP)        
                  
    else   if isSubscribed = true
        list.push(item2)
        list.push(watchLi)      
        list.push(SubItem)      
    end if   
   
    
    hdposter = "pkg://locale/default/images/SearchHD.jpg"
    sdposter = "pkg://locale/default/images/SearchSD.jpg"
    item =  CreateListItem("", "", "",hdposter, sdposter)
    item.process =  searchscreen
    item.title = "Search"
    item.Description = "Search for videos"
    list.push(item)   
  
    return list 
end function


function CreateListItem(title as string, desc1 as string , desc2 as string, hdPoster as string, sdPoster as string ) as Object
     signin = CreateObject("roAssociativeArray")
     signin.ShortDescriptionLine1 = desc1 
     signin.ShortDescriptionLine2 = desc2
     signin.title = title
     signin.HDPosterUrl = hdPoster
     signin.SDPosterUrl = sdPoster
    return signin 
end function 


function slideDetailScreen( item as Object)
        itemDetail = CallApi("video", item.videoid)
        itemDetail = itemDetail.responseData
        itemRating  =  itemDetail.rating
        item.comments  =  itemDetail.comments
        'print  itemRating
        'SetHomeTheme()
        setTheme()
        
        port = CreateObject("roMessagePort")
        springBoard = CreateObject("roSpringboardScreen")
        'springBoard.SetBreadcrumbText("[location 1]", "[location2]")
        springBoard.SetMessagePort(port)
        o = CreateObject("roAssociativeArray")
        'o.ContentType = "episode"
        o.Title =  itemDetail.title
        o.ShortDescriptionLine1 = itemDetail.title
        'o.ShortDescriptionLine2 = 
        o.Description = itemDetail.uniqueDescription
       
        o.SDPosterUrl =  itemDetail.rokuImageUrl 'imageUrl
        o.HDPosterUrl = itemDetail.rokuImageUrl 'imageUrl
        'o.Rating = "NR"
         ratingItem =     itemRating * 20
         o.StarRating = ratingItem 
        '
        o.Actors = CreateObject("roArray", 10, true)

        springBoard.SetContent(o)
        springboard.SetPosterStyle("rounded-rect-16x9-generic")
        springBoard.AddButton(1,"Play")
        if(item.watchList = "YES")
            springBoard.AddButton(7,"Remove from Watch Later")
        else
            springBoard.AddButton(2,"Watch Later")
        end if
        springBoard.AddButton(3,"Star Rating")
        'springBoard.AddButton(4,"Add  Comment")
        springBoard.AddButton(5,"Show Comments")
        springBoard.AddButton(6,"Home Screen")
        'springBoard.EnableBackButton()
        springBoard.Show()
            While True
            msg = wait(0, port)
            'print msg.GetIndex()           
            If msg.isScreenClosed() Then
                busydialog = showBusyMethod(springBoard)  
                homeScreen(busydialog)             
            Else if msg.isButtonPressed()
                    'print "msg: "; msg.GetMessage(); "idx: "; msg.GetIndex()
                        if msg.GetIndex() = 1 then
                                'PLAY VIDEO 
                                playvideo(item)
                         ELSE if msg.GetIndex() = 2 then
                                'ADD VIDEO TO WATCH LIST
                                addToWatchList(item)
                          ELSE if msg.GetIndex() = 3 then
                                'ADD Star Rating TO VIDEO
                                AssignStarRating(item)
                         ELSE if msg.GetIndex() = 4 then
                                'ADD Comments TO VIDEO
                                addComments(item)
                          ELSE if msg.GetIndex() = 5 then
                                'show Comments for VIDEO
                                showComments(item, 0)
                         ELSE if msg.GetIndex() = 6 then
                                'show Comments for VIDEO
                                busydialog = showBusyMethod(springBoard)  
                                homeScreen(busydialog)
                          ELSE if msg.GetIndex() = 7 then
                                'show Comments for VIDEO
                                removefromWatchList(item)                
                        end if
                        
             Endif
            End While       
end function

function showBusyMethod (screen)
    setTheme()
    busydialog=CreateObject("roOneLineDialog")
    busydialog.SetMessagePort(screen.GetmessagePort())
    busydialog.SetTitle("Loading ...") 'credit from "I dream of Jeannie"
    busydialog.ShowBusyAnimation()
    busydialog.Show()
    return busydialog
end function

function removefromWatchList(Item as dynamic)
    BaseUrl = "http://cms.xivetv.com/api/"
	'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
                        apiRequestUrl =   BaseUrl+"removewatchlater"
                              'apiRequestUrl =   BaseUrl
                        ApiRequest = CreateObject("roUrlTransfer")
                        port = CreateObject("roMessagePort")
                        ApiRequest.SetMessagePort(port)
                        ApiRequest.SetURL(apiRequestUrl)
                        ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
                        user = getUserDetails()        
                        id= Item.videoid.toStr()
                         postString = "itemType=v&userId="+user.userId+"&itemId="+id
                         if ( ApiRequest.AsyncPostFromString(postString) )
                            while (true)
                              msg = wait(0, port)
                               if (type(msg) = "roUrlEvent")
                                 code = msg.GetResponseCode()
                                if (code = 200)
                                  res = ParseJSON(msg.GetString())
                                  if(res.responseCode = 200)
                                        showErrorDialog("Success Notification", "Video removed successfully from Watch list")
                                        watchListScreen()
                                  else if(res.responseCode = 403)
                                        showErrorDialog("Notification", res.responseMessage)      
                                  end if                                                                      
                                endif                                    
                              end if
                            end while
                           end if  
    
end function

function addComments( Item as Object )
       if( getAuthSetting() = "FAILED" )      
               LoginAlert(Item)
       else
            'setSearchScreenTheme()
            setTheme()
            screen = CreateObject("roKeyboardScreen")
            port = CreateObject("roMessagePort")
            screen.SetMessagePort(port)
            screen.SetTitle("Enter your comments")
           screen.SetMaxLength(255)
            screen.AddButton(1, "Add Comment")
            screen.AddButton(2, "Cancel")
            screen.Show()
            while true
                msg = wait(0, screen.GetMessagePort())
                    
                    if type(msg) = "roKeyboardScreenEvent"
                        if msg.isScreenClosed()
                            showComments(Item,0)
                        else if msg.isButtonPressed() then                            
                              if msg.GetIndex() = 1
                                 commentText  =  screen.getText()
                                 commentText =  commentText.Trim()
                                    if commentText <> "" then 
                                      addCommentsToSystem( Item, commentText)
                                    else 
                                      showErrorDialog("Error Notification", "Please enter comment text")
                                 end if
                               else if msg.GetIndex() = 2         
                                        exit while
                              endif   
                    endif
                endif
            end while
         end if              
End function

function addCommentsToSystem(Item as Object , commentText as string)
        BaseUrl = "http://cms.xivetv.com/api/"
		'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
        apiRequestUrl =   BaseUrl+"comment"
              'apiRequestUrl =   BaseUrl
        ApiRequest = CreateObject("roUrlTransfer")
        port = CreateObject("roMessagePort")
        ApiRequest.SetMessagePort(port)
        ApiRequest.SetURL(apiRequestUrl)
        ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
        user = getUserDetails()        
        id= Item.videoid.toStr()
         postString = "itemType=v&userId="+user.userId+"&itemId="+id+"&comment="+commentText
         if ( ApiRequest.AsyncPostFromString(postString) )
                while (true)
                      msg = wait(0, port)
                       if (type(msg) = "roUrlEvent")
                             code = msg.GetResponseCode()
                            if (code = 200)
                                        res = ParseJSON(msg.GetString())
                                          if(res.responseCode = 200)
                                                 showErrorDialog("Success Notification", "Comment posted successfully ")                                                       
                                         else if(res.responseCode = 403)
                                                 showErrorDialog("Notification", res.responseMessage)      
                                        end if                                                                      
                            endif
                            slideDetailScreen(Item) 
                      end if
                end while
           end if   
End function 

Function addToWatchList(Item as Object)
          if( getAuthSetting() = "FAILED" )      
                LoginAlert(Item)
           else     
          
                        BaseUrl = "http://cms.xivetv.com/api/"
						'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
                        apiRequestUrl =   BaseUrl+"savewatchlater"
                              'apiRequestUrl =   BaseUrl
                        ApiRequest = CreateObject("roUrlTransfer")
                        port = CreateObject("roMessagePort")
                        ApiRequest.SetMessagePort(port)
                        ApiRequest.SetURL(apiRequestUrl)
                        ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
                        user = getUserDetails()        
                        id= Item.videoid.toStr()
                         postString = "itemType=v&userId="+user.userId+"&id="+id
                         if ( ApiRequest.AsyncPostFromString(postString) )
                                while (true)
                                      msg = wait(0, port)
                                       if (type(msg) = "roUrlEvent")
                                             code = msg.GetResponseCode()
                                            if (code = 200)
                                                        res = ParseJSON(msg.GetString())
                                                          if(res.responseCode = 200)
                                                                if(res.responseData.watchLatterId > 0  )
                                                                        showErrorDialog("Success Notification", "Video successfully added to Watch list")
                                                                  end if       
                                                         else if(res.responseCode = 403)
                                                                 showErrorDialog("Notification", res.responseMessage)      
                                                        end if                                                                      
                                            endif
                                            slideDetailScreen(Item) 
                                      end if
                                end while
                           end if   
          end if
End function 


Function AssignStarRating(Item as Object)
      if( getAuthSetting() = "FAILED" )      
                LoginAlert(Item)
        else        
                                
                        port = CreateObject("roMessagePort")
                        dialog = CreateObject("roMessageDialog")
                        dialog.SetMessagePort(port) 
                        dialog.SetTitle("Enter rating for the video")
                        
                        dialog.AddButton(5, "5 Star")
                        dialog.AddButton(4, "4 Star")
                        dialog.AddButton(3, "3 Star")
                        dialog.AddButton(2, "2 Star")
                        dialog.AddButton(1, "1 Star")
                        dialog.AddButton(6, "Cancel")
                        dialog.EnableBackButton(true)
                        dialog.Show()
                        While True
                            dlgMsg = wait(0, dialog.GetMessagePort())
                            If type(dlgMsg) = "roMessageDialogEvent"
                                if dlgMsg.isButtonPressed()
                                    if dlgMsg.GetIndex() = 1
                                             updateStarRating(1, Item,  dialog)
                                    else if dlgMsg.GetIndex() = 2
                                            updateStarRating(2, Item, dialog)
                                    else if dlgMsg.GetIndex() = 3
                                            updateStarRating(3, Item,  dialog)
                                    else if dlgMsg.GetIndex() = 4
                                           updateStarRating(4, Item,  dialog)
                                    else if dlgMsg.GetIndex() = 5
                                           updateStarRating(5, Item, dialog) 
                                    else if dlgMsg.GetIndex() = 6
                                        return returnBack
                                    end if
                                else if dlgMsg.isScreenClosed()
                                    exit while
                                end if
                            end if
                        end while
         end if                
End Function

Function LoginAlert(Item as object)
     port = CreateObject("roMessagePort")
    dialog = CreateObject("roMessageDialog")
    dialog.SetMessagePort(port) 
    dialog.SetTitle("Login Alert")
     dialog.SetTitle("Please login to perform this action")
     dialog.AddButton(1, "Ok")
     'dialog.AddButton(2, "Cancel")
     dialog.EnableBackButton(false)
    dialog.Show()
    While True
        dlgMsg = wait(0, dialog.GetMessagePort())
        If type(dlgMsg) = "roMessageDialogEvent"
            if dlgMsg.isButtonPressed()
                if dlgMsg.GetIndex() = 1
                                'LoginScreen()
                'else if dlgMsg.GetIndex() = 2
                                exit while        
                 else if dlgMsg.isScreenClosed()
                        exit while
                 end if     
            end if 
       end if 
    end while           
End Function


function   updateStarRating( rating as integer, Item as Object, dial as Dynamic)
        dial.close()
         BaseUrl = "http://cms.xivetv.com/api/"
		 'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
        apiRequestUrl =   BaseUrl+"rating"
              'apiRequestUrl =   BaseUrl
        ApiRequest = CreateObject("roUrlTransfer")
        port = CreateObject("roMessagePort")
        ApiRequest.SetMessagePort(port)
        ApiRequest.SetURL(apiRequestUrl)
        ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
        user = getUserDetails()        
        id= Item.videoid.toStr()
         postString = "itemType=v&userId="+user.userId+"&itemId="+id+"&rating="+rating.toStr()
         if ( ApiRequest.AsyncPostFromString(postString) )
                while (true)
                      msg = wait(0, port)
                       if (type(msg) = "roUrlEvent")
                             code = msg.GetResponseCode()
                            if (code = 200)
                                        res = ParseJSON(msg.GetString())
                                          if(res.responseCode = 200)
                                                 showErrorDialog("Success Notification", "Rating updated for the video")                                                       
                                         else if(res.responseCode = 403)
                                                 showErrorDialog("Notification", res.responseMessage)      
                                        end if                                                                      
                            endif
                            slideDetailScreen(Item) 
                      end if
                end while
           end if   

end function    


function showComments(Item as dynamic, startCount as integer)
            'setSearchScreenTheme()
            setTheme()
            port = CreateObject("roMessagePort")
            screen = CreateObject("roParagraphScreen")
            screen.SetMessagePort(port)
            screen.SetTitle("Comments")
            screen.AddHeaderText( Item.title +" - Comments")
            'print Item.comments.Count()
            maxLimit  = startCount + 1
            if(maxLimit >= Item.comments.Count())
                maxLimit = Item.comments.Count() - 1
            End if
            
            'Next Button           
            if Item.comments.Count() = 0
                screen.AddParagraph("No Comments to show")
              else     
                For i= startCount  To maxLimit Step 1 
                   if Item.comments[i].commentDesc.Len() > 335 
                      CommentContent =  Item.comments[i].commentDesc.Left(332)+"... - By "+ Item.comments[i].name
                   else
                    CommentContent = Item.comments[i].commentDesc +"- By "+ Item.comments[i].name
                    
                   end if   
                    screen.AddParagraph(CommentContent)                        
                end for
                 
                IF Item.comments.Count() <> maxLimit + 1 and Item.comments.Count() > 2
                        screen.AddButton(1, "Next Comments")    
                End IF
              end if
            'Previous Button
             IF   startCount > 0
                screen.AddButton(5, "Previous Comments")
             END IF
              
            screen.AddButton(3, "Add Comments")
            screen.AddButton(2, "Video Detail Page")
            screen.Show()
            
            while true
        msg = wait(0, screen.GetMessagePort())
          
            if type(msg) = "roParagraphScreenEvent"
                if msg.isScreenClosed()
                  slideDetailScreen(Item)
                else if msg.isButtonPressed() then
                    if msg.GetIndex() = 1
                          showComments(Item , startCount + 2)
                    else  if msg.GetIndex() = 2
                          slideDetailScreen(Item)
                    else  if msg.GetIndex() = 3
                          addComments(item)
                    else  if msg.GetIndex() = 5
                          showComments(Item , startCount - 2)
                    endif   
             endif
        endif
    end while
End function 