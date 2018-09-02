function getAuthSetting() as dynamic
        sec = CreateObject("roRegistrySection", "Authentication")
        if sec.Exists("UserRegistrationToken")
            return sec.Read("UserRegistrationToken")
        endif
        return "FAILED"  
End function

function getUserDetails() as dynamic
        user = CreateObject("roAssociativeArray")
        sec = CreateObject("roRegistrySection", "UserDetails")
        if sec.Exists("UserId")
                user.userId = sec.Read("UserId")
         else        
                user.userId = ""
        endif
        
        if sec.Exists("Token")
                user.token = sec.Read("Token")
         else        
                user.token =  ""     
        endif
        
        if sec.Exists("Email")
                user.email= sec.Read("Email")
         else        
                user.email =    ""   
        endif        
        return user  
End function


function setUserDetails(userId as string, email as string, token as string )
       sec = CreateObject("roRegistrySection", "UserDetails")
       sec.Write("UserId", userId)
       sec.Write("Token", token)
       sec.Write("Email",  email)
       sec.Flush()        
End function



Function  setAuthSetting( userDetails as  String)
        sec = CreateObject("roRegistrySection", "Authentication")
        sec.Write("UserRegistrationToken",userDetails)
        sec.Flush()        
End Function  


Function  setSubSetting( Subsc as  String, dialog as dynamic)
        sec = CreateObject("roRegistrySection", "Subscription")
        sec.Write("Subscription",Subsc)
        sec.Flush()
        homeScreen(dialog)
End Function  

function getSubSetting() as dynamic
        sec = CreateObject("roRegistrySection", "Subscription")
        if sec.Exists("Subscription")
            return sec.Read("Subscription")
        endif
        return "FAILED"  
End function


Function  removeAuthSetting(dialog as dynamic)
        sec = CreateObject("roRegistrySection", "Authentication")
        if sec.Exists("UserRegistrationToken")
            sec.Delete("UserRegistrationToken")
            sec.Flush()
        end if 
        sec1 = CreateObject("roRegistrySection", "UserDetails")
         if sec1.Exists("UserId")
                sec1.Delete("UserId")
         endif
         
         if sec1.Exists("Token")
                sec1.Delete("Token")
         endif
         
         if sec1.Exists("Email")
                sec1.Delete("Email")
         endif
         sec1.Flush()
         busydialog = showBusyMethod(dialog)  
         homeScreen(busydialog)
End Function  

Function LoginScreen()
    'setSearchScreenTheme()
    setTheme()
    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort")
    channel = CreateObject("roChannelStore")
    channel.SetMessagePort(port)
    screen.SetMessagePort(port)
    screen.SetTitle("Login Screen - Email")
    'screen.SetText("a@a.com")
    m.screenP = screen
    'screen.SetSecureText(true)
    screen.AddButton(1, "Next")
    screen.AddButton(3, "Create New User")
    screen.AddButton(2, "Cancel")
    screen.Show()
    
    resultEmail=""
    result =  channel.GetPartialUserData("email")
    if(result = invalid)
        resultEmail = ""
    Else
      resultEmail = result.email
      PasswordScreen(resultEmail)
    End If
    screen.SetText(resultEmail)
    
    while true
        msg = wait(0, screen.GetMessagePort())
          
            if type(msg) = "roKeyboardScreenEvent"
                if msg.isScreenClosed()
                    busydialog = showBusyMethod(screen)  
                    homeScreen(busydialog)
                else if msg.isButtonPressed() then
                    if msg.GetIndex() = 1
                        emailId = screen.GetText()
                         if emailId <> ""
                            PasswordScreen(emailId)
                         else 
                            'print "Enter you mail id"
                            emailError()
                         end if
                    else  if msg.GetIndex() = 2
                             busydialog = showBusyMethod(screen)  
                              homeScreen(busydialog)
                        else  if msg.GetIndex() = 3
                                EnterName()
                    endif   
            endif
        endif
    end while    
End Function


Function PasswordScreen( UserName as string)
    'setSearchScreenTheme()
    setTheme()
    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetTitle("Login Screen - Password")
    'screen.SetText("123456")
    screen.SetMaxLength(50)
    screen.SetSecureText(true)
    screen.AddButton(1, "Back")
    screen.AddButton(2, "Login")
    screen.Show()
    while true
        msg = wait(0, screen.GetMessagePort())
            
            if type(msg) = "roKeyboardScreenEvent"
                if msg.isScreenClosed()
                  return -1
                else if msg.isButtonPressed() then                            
                    if msg.GetIndex() = 1
                        return -1
                    else  if msg.GetIndex() = 2
                        password  = screen.GetText()
                         if password <> "" then 
                            validateLogin(UserName, password, screen)
                         else 
                            passwordError()
                         end if
                     endif   
            endif
        endif
    end while
End Function 

function validateLogin( UserName , password, screen as dynamic  )
             ba1 = CreateObject("roByteArray")
             ba1.FromAsciiString(password)
            digest = CreateObject("roEVPDigest")
            digest.Setup("md5")
            digest.Update(ba1)
            passwordEncoded =   digest.Final()            

              BaseUrl = "http://cms.xivetv.com/api/"
			 'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
              apiRequestUrl =   BaseUrl+"login"
              'apiRequestUrl =   BaseUrl
              ApiRequest = CreateObject("roUrlTransfer")
              port = CreateObject("roMessagePort")
              ApiRequest.SetMessagePort(port)
                            
            ApiRequest.SetURL(apiRequestUrl)
           ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
          
         postString = "userId="+UserName+"&password="+passwordEncoded                
          if ( ApiRequest.AsyncPostFromString(postString) )
                while (true)
                      msg = wait(0, port)
                       if (type(msg) = "roUrlEvent")
                             code = msg.GetResponseCode()
                             if (code = 200)
                                        res = ParseJSON(msg.GetString())
                                        'print res.responseData
                                        'setAuthSetting(res.responseData.subscriptionDetail.isSubscribed) 
                                        responseMsg = res.responseCode
                                         subs = false
                                         'print subs
                                         'subs = true
                                         if( responseMsg =200)
                                                setAuthSetting("SUCCESS")     
                                                subs = res.responseData.subscriptionDetail.isActiveSubscription                                           
                                                setUserDetails(res.responseData.userId.toStr(), res.responseData.email, res.responseData.token)
                                         else     
                                                setAuthSetting("FAILED")
                                                showErrorDialog("Login Failed",res.responseMessage)
                                                
                                         end if 
                                         
                                         if subs = true
                                                dialog = showBusyMethod(screen)
                                                setSubSetting("SUCCESS", dialog)
                                         else     
                                                dialog =  showBusyMethod(screen)
                                                setSubSetting("FAILED", dialog)
                                         end if 
                                         'm.isSubscribed = true
                                         'homeScreen()     
                            endif 
                      end if       
                       
                end while
           end if            
                      
           
end function 

Function LogoutScreen()
 'print "in logout Action"
    titleText ="Logout Confirmation"
    titleDesc="Do you want to logout?"
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    port = CreateObject("roMessagePort")
    dialog = CreateObject("roMessageDialog")
    dialog.SetMessagePort(port) 
    dialog.SetTitle(titleText)
    dialog.SetText(titleDesc)
 
    dialog.AddButton(1, "OK")
    dialog.AddButton(2, "Cancel")
    dialog.EnableBackButton(true)
    dialog.Show()
    While True
        dlgMsg = wait(0, dialog.GetMessagePort())
        If type(dlgMsg) = "roMessageDialogEvent"
            if dlgMsg.isButtonPressed()
                 if dlgMsg.GetIndex() = 1
                        dialogScreen = showBusyMethod(dialog)
                        removeAuthSetting(dialogScreen)                        
                else if dlgMsg.GetIndex() = 2
                    dialog.Close()
                end if
            else if dlgMsg.isScreenClosed()
                        'return -1
                exit while
            end if
        end if
    end while 
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
End Function


