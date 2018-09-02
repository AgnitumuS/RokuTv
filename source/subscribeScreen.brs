Function subscribeScreen() as void
    SetTheme()
    this = {     
     screen : CreateObject("roListScreen")
     port :   CreateObject("roMessagePort")
     store :   CreateObject("roChannelStore")
     PlaceOrder : PlaceOrderFull
     storeItemList : []
     purchased_items: []
     GetUserPurchases: get_user_purchases
     GetProduct  :  getProductCatalog
     SubUpdate : recordSubscriptionUpdate
     GetContentList : getProductList
    } 
  
  'this.screen.setTitle("Product")
  this.screen.SetMessagePort(this.port)
  this.store.SetMessagePort(this.port)
  'this.store.FakeServer(true)
  this.screen.SetBreadcrumbText("", "Home")
  this.screen.show()
  this.GetUserPurchases()
  this.GetProduct()
  
  
  while(true)
     msg = wait(0, this.port)
     'print type(msg)
     If (type(msg) = "roListScreenEvent")
         If msg.isScreenClosed()
         exit while
            'busydialog = showBusyMethod(this.screen)  
           ' homeScreen(busydialog)           
         ELSE IF msg.isListItemSelected()
           index =  msg.GetIndex()
           result = this.PlaceOrder(index)
           If result = false
               exit while
           End If                    
            End If     
     Else If (type(msg) = "roChannelStoreEvent")
            'print "In Order response"
            OrderDetail  =  msg.GetResponse()
            'getPurchaseId(OrderDetail)
            purchaseId  = getPurchaseId(OrderDetail)
            this.SubUpdate(purchaseId)
            
            'this.DumpResponse(OrderDetail)
     End If    
  End While    
   
 End Function
 
 
 Function getProductCatalog()
    m.store.GetCatalog()
    while(true)
        msg = wait(0, m.port)
        'Print "getCatalog"
        'print msg.GetResponse()
        If (type(msg) = "roChannelStoreEvent")
            if msg.isRequestSucceeded()
                m.GetContentList(msg.GetResponse())
                m.screen.SetContent(m.storeItemList)
                m.screen.show()
            else if msg.isRequestFailed()
            
            end if
            exit while  
        End if 
    End while
 End Function 
 
 Function getProductList(Items as Dynamic)
    IF Items.count() = 0
         list_item = {
                Title: "No Item  available"
                ID: stri(0)
                code: ""
                cost: ""
            }
        m.storeItemList.Push(list_item)     
    END IF
    i = 0
    arr = []
    for each item in items
        i = i+1
    owned = false
    for each purchased_item in m.purchased_items
        if (item.code = purchased_item.code)
           owned = true
           exit for
        end if
    end for
    list_item = {
        Title: item.name
        ID: stri(i)
        code: item.code
        cost: item.cost
    }
    if (owned = true)
        list_item.HDSmallIconUrl = "pkg:/locale/default/images/checkmark.png"
        list_item.SDSmallIconUrl = "pkg:/locale/default/images/checkmark.png"
    end if
    m.storeItemList.Push(list_item)
    end for
 End Function
 
Function PlaceOrderFull( Index as  integer) as boolean

 'resultConfirm = m.store.GetUserData()
 resultConfirm = m.store.GetPartialUserData("email,firstname,lastname")
   If resultConfirm  = invalid
        return false
   End If
               
order  = [{code : m.storeItemList[Index].code ,qty :1}]
m.store.setOrder(order)
result = m.store.DoOrder()
return result
End Function       

Function getPurchaseId(list as object) as Dynamic
    PurObj =  createObject("roAssociativeArray")
    for each key in list
        for each k in  key
          If(k = "purchaseId")then 
            purObj["purchaseId"] = key[k]
          Else If (k = "code") then
            purObj["code"] = key[k]
          End if 
        end for 
    end for 
return PurObj
End Function

Function recordSubscriptionUpdate( SubObj as Dynamic ) as boolean

    if SubObj.PurchaseId = ""
        return false
    end if 
    BaseUrl = "http://cms.xivetv.com/api/"
	 'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
    apiRequestUrl =   BaseUrl+"subscription"
    ApiRequest = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    ApiRequest.SetMessagePort(port)            
    ApiRequest.SetURL(apiRequestUrl)
    ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
    user = getUserDetails() 
    date = CreateObject("roDateTime")
    dateString  = date.getYear().toStr()+"-"+stringPad(date.getMonth().tostr())+"-"+stringPad(date.getDayOfMonth().tostr())  
    postString = "userId="+user.userId+"&subscriptionId=4&paymentId="+SubObj.PurchaseId+"&startDate="+dateString
    
    if ( ApiRequest.AsyncPostFromString(postString) )
        while (true)
             msg = wait(0, port)
             if(type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    res = ParseJSON(msg.GetString())
                    responsecode = res.responseCode
                    if(responsecode =200)
                        showErrorDialog("Subscription Successfully", "You have subscribed successfully to channel")
                        dialog = showBusyMethod(m.screen)
                        setSubSetting("SUCCESS", dialog)
                    Else 
                      showErrorDialog("Subscription Failed", "Your attempt to subscribe failed. Please try again later")
                      dialog = showBusyMethod(m.screen)
                       setSubSetting("SUCCESS", dialog)
                    End If
                end if
             end If
        End While
    End If      
End Function

Function stringPad(dateStr as string )as string
if dateStr.Len() =  1
    dateStr = "0"+dateStr 
end if
return dateStr
End Function 


Function checkUserSubscription()
    user = getUserDetails()  
   
            res  =  CallApi("profile",user.userId.toInt())
     
             If(res.responseCode = 200)
                SubDetail  = res.responseData.subscriptionDetail.isActiveSubscription
                sec = CreateObject("roRegistrySection", "Subscription")
                If SubDetail =  true
                  sec.Write("Subscription","SUCCESS")
                Else 
                  sec.Write("Subscription","FAILED")          
                End If
                sec.Flush()
            End If
  

End Function 

Function get_user_purchases() as void
    m.store.GetPurchases()
    while (true)
        msg = wait(0, m.port)
        if (type(msg) = "roChannelStoreEvent")
            if (msg.isRequestSucceeded())
            for each item in msg.GetResponse()
            m.purchased_items.Push({
            Title: item.name
            code: item.code
            cost: item.cost
             }) 
            end for
        exit while
        else if (msg.isRequestFailed())
        end if
        end if
    end while
End Function

