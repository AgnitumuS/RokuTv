function  EnterName()
    'setSearchScreenTheme()
    setTheme()
    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort")
    channel  = CreateObject("roChannelStore")
    channel.SetMessagePort(port)
    screen.SetMessagePort(port)
    screen.SetTitle("Signup - Please enter Name")        
    screen.SetText("")
    'screen.SetSecureText(true)
    screen.AddButton(1, "Next")
    screen.AddButton(2, "Login")
    screen.AddButton(3, "Home Screen")
    screen.Show()
    
    result =  channel.GetPartialUserData("email,firstname,lastname")
    if(result = invalid)
        'Dummy Body
    Else
      resultEmail = result.email
      FullName = result.firstname+" "+result.lastname.trim()
      PassowrdScreenUser(FullName, resultEmail)
    End If
    
    
    while true
        msg = wait(0, screen.GetMessagePort())
          
            if type(msg) = "roKeyboardScreenEvent"
                if msg.isScreenClosed()
                    busydialog = showBusyMethod(screen)  
                    homeScreen(busydialog)
                else if msg.isButtonPressed() then
                                        if msg.GetIndex() = 1
                                            Name = screen.GetText()
                                             if Name <> ""
                                                screen.SetText("")
                                                emailScreen(Name)
                                             else 
                                                'print "Enter you mail id"
                                                showErrorDialog("Error Notification", "Please enter Name")
                                             end if
                                        else  if msg.GetIndex() = 2
                                                LoginScreen()
                                         else  if msg.GetIndex() = 3
                                               busydialog = showBusyMethod(screen)  
                                               homeScreen(busydialog)
                                        endif   
            endif
        endif
    end while
end function 

function emailScreen(Name as string)
        'setSearchScreenTheme()
        setTheme()
        screen = CreateObject("roKeyboardScreen")
        port = CreateObject("roMessagePort")
        screen.SetMessagePort(port)
        screen.SetTitle("Signup - Please enter Email")
        'screen.SetText("ab@a.com")
        'screen.SetSecureText(true)
        screen.AddButton(1, "Next")
        screen.AddButton(2, "Back")
        screen.AddButton(3, "Home Screen")
        screen.Show()
        while true
            msg = wait(0, screen.GetMessagePort())
              
                if type(msg) = "roKeyboardScreenEvent"
                    if msg.isScreenClosed()
					return -1
				else if msg.isButtonPressed() then
                                            if msg.GetIndex() = 1
                                                email = screen.GetText()
                                              '  print email
                                                 if email <> ""
                                                    screen.SetText("")
                                                    PassowrdScreenUser(Name, email)
                                                 else 
                                                    'print "Enter you mail id"
                                                    showErrorDialog("Error Notification", "Please enter Email")
                                                 end if
                                            else  if msg.GetIndex() = 2
                                                    return -1
                                             else  if msg.GetIndex() = 3
                                               busydialog = showBusyMethod(screen)  
                                               homeScreen(busydialog)        
                                  endif   
                endif
            endif
        end while
end function

function  PassowrdScreenUser(Name  as string, Email  as string)
        'setSearchScreenTheme()
        setTheme()
        screen = CreateObject("roKeyboardScreen")
        port = CreateObject("roMessagePort")
        screen.SetMessagePort(port)
        screen.SetTitle("Signup - Please enter Password")
        'screen.SetText("111111")
        screen.SetMaxLength(50)
        screen.SetSecureText(true)
        screen.AddButton(1, "Next")
        screen.AddButton(2, "Back")
        screen.AddButton(3, "Home Screen")
        screen.Show()
        while true
            msg = wait(0, screen.GetMessagePort())
              
                if type(msg) = "roKeyboardScreenEvent"
                    if msg.isScreenClosed()
                         return -1
                    else if msg.isButtonPressed() then
                                            if msg.GetIndex() = 1
                                                password = screen.GetText()
                                                 if password <> ""
                                                    screen.SetText("")
                                                    ConfirmPasswordScreen(Name, Email, password)
                                                 else 
                                                    'print "Enter you mail id"
                                                      showErrorDialog("Error Notification", "Please enter Password")
                                                 end if
                                            else  if msg.GetIndex() = 2
                                                    return -1
                                             else  if msg.GetIndex() = 3
                                               busydialog = showBusyMethod(screen)  
                                               homeScreen(busydialog)        
                                            endif   
                endif
            endif
        end while

end function 

function  ConfirmPasswordScreen(Name  as string , Email  as string , Password  as string)
        'setSearchScreenTheme()
        setTheme()
        screen = CreateObject("roKeyboardScreen")
        port = CreateObject("roMessagePort")
        screen.SetMessagePort(port)
        screen.SetTitle("Signup - Confirm Password")
        'screen.SetText("111111")
        screen.SetMaxLength(50)
        screen.SetSecureText(true)
        screen.AddButton(1, "Create User")
        screen.AddButton(2, "Back")
        screen.AddButton(3, "Home Screen")
        screen.Show()
        while true
            msg = wait(0, screen.GetMessagePort())
                
                if type(msg) = "roKeyboardScreenEvent"
                    if msg.isScreenClosed()
                      return -1
                    else if msg.isButtonPressed() then
                                            if msg.GetIndex() = 1
                                                Confirmpassword = screen.GetText()
                                                 if Confirmpassword =  Password
                                                        screen.SetText("")
                                                        RegisterUser(Name, Email, Password, screen)
                                                 else if Confirmpassword <>  Password
                                                        showErrorDialog("Error Notification", "Password and Confirm Password should be same")
                                                  else  
                                                      showErrorDialog("Error Notification", "Please confirm Password")
                                                 end if
                                            else  if msg.GetIndex() = 2
                                                    return -1
                                             else  if msg.GetIndex() = 3
                                               busydialog = showBusyMethod(screen)  
                                               homeScreen(busydialog)        
                                            endif   
                endif
            endif
        end while
end function 


function RegisterUser(Name  as string , Email  as string, Password  as string, screen as dynamic)
 '       print Name
 '       print Email
  '      print Password
        ba1 = CreateObject("roByteArray")
             ba1.FromAsciiString(Password)
            digest = CreateObject("roEVPDigest")
            digest.Setup("md5")
            digest.Update(ba1)
            passwordEncoded =   digest.Final()            
    
              BaseUrl = "http://cms.xivetv.com/api/"
			  'BaseUrl = "http://alliant.icreondemoserver.com/api/"   
              apiRequestUrl =   BaseUrl+"signup"
              'apiRequestUrl =   BaseUrl
              ApiRequest = CreateObject("roUrlTransfer")
              port = CreateObject("roMessagePort")
              ApiRequest.SetMessagePort(port)
                            
            ApiRequest.SetURL(apiRequestUrl)
           ApiRequest.AddHeader("Authorization","eyJhdXRoa2V5IjoiMTIzNDU2Nzg5IiwidXNlcklkIjoiIiwicGFzc3dvcmQiOiIiLCJhdXRoVG9rZW4iOiIifQ")
          
         postString = "name="+Name+"&email="+Email+"&password="+passwordEncoded
         'postString = "userId="+UserName+"&password="+passwordEncoded         
              if ( ApiRequest.AsyncPostFromString(postString) )
                while (true)
                      msg = wait(0, port)
                       if (type(msg) = "roUrlEvent")
                             code = msg.GetResponseCode()
                            if (code = 200)
                                        res = ParseJSON(msg.GetString())
                                        'print res.responseData
                                        'setAuthSetting(res.responseData.subscriptionDetail.isSubscribed) 
                                         subs = res.responseCode
                                         if(subs = 200)
                                                showErrorDialog("Success", "User created successfully")
                                                setAuthSetting("SUCCESS")
                                                setUserDetails(res.responseData.userId.toStr(), res.responseData.email, res.responseData.token)
                                                dialog  =  showBusyMethod(screen)
                                                setSubSetting("FAILED", dialog)
                                                'homeScreen()
                                          else 
                                                  showErrorDialog("Error Notification", res.responseMessage)
                                                  EnterName()
                                         end if 
                                         'subs = true                                           
                            endif 
                      end if       
                       
                end while
           end if            
end function

function showErrorDialog(titleText , titleDesc)
    'print "error dialog"
    'SetHomeTheme()
    setTheme()
    port = CreateObject("roMessagePort")
    dialog = CreateObject("roMessageDialog")
    dialog.SetMessagePort(port) 
    dialog.SetTitle(titleText)
    dialog.SetText(titleDesc)
 
    dialog.AddButton(1, "OK")
    'dialog.AddButton(2, "Cancel")
    dialog.EnableBackButton(true)
    dialog.Show()
    While True
        dlgMsg = wait(0, dialog.GetMessagePort())
        If type(dlgMsg) = "roMessageDialogEvent"
            if dlgMsg.isButtonPressed()
                 if dlgMsg.GetIndex() = 1
                    dialog.Close()
                else if dlgMsg.GetIndex() = 2
                    dialog.Close()
                end if
            else if dlgMsg.isScreenClosed()
                        'return -1
                exit while
            end if
        end if
    end while 
end function