Function signinScreen()
     REM Function to set the theme
     setSearchScreenTheme()
     
     screen = CreateObject("roKeyboardScreen")
     port = CreateObject("roMessagePort") 
     screen.SetMessagePort(port)
     screen.SetTitle("Search Screen")
     
     REM function to set the default string in input text box
     'screen.SetText("Enter Your EmailId")
     
     screen.SetDisplayText("Enter Your Email Id")
     
     REM function to set the maximum length of input text box
     screen.SetMaxLength(30)
     screen.SetTitle("Sign In")
     screen.AddButton(1, "Next")
     screen.AddButton(2, "Back")
     screen.Show() 
  
     while true
         msg = wait(0, screen.GetMessagePort()) 
         if type(msg) = "roKeyboardScreenEvent" then
             if msg.isScreenClosed() then
                 'return -1
				 exit while
             else if msg.isButtonPressed() then
                 if msg.GetIndex() = 1 then 
                     emailId = screen.GetText()
                     if emailId <> ""
                        getPassword(emailId)
                     else 
                        emailError()
                     end if
                 else if msg.GetIndex() = 2
                     'return -1
					 exit while
                 endif
             endif
         endif
     end while 
 End Function
 
 
 Function getPassword(emailId as String)
     REM Function to set the theme
     setSearchScreenTheme()
     
     emailId = emailId
     screen = CreateObject("roKeyboardScreen")
     port = CreateObject("roMessagePort") 
     screen.SetMessagePort(port)
     screen.SetTitle("Search Screen")
     
     REM function to set the default string in input text box
     'screen.SetText("Enter Your Password")
     
     screen.SetDisplayText("Enter Your Password")
     
     REM function to set the maximum length of input text box
     screen.SetMaxLength(30)
     screen.SetTitle("Sign In")
     screen.AddButton(1, "Login")
     screen.AddButton(2, "Back")
     screen.Show() 
  
     while true
         msg = wait(0, screen.GetMessagePort()) 
         if type(msg) = "roKeyboardScreenEvent" then
             if msg.isScreenClosed() then
                 'return -1
				 exit while
             else if msg.isButtonPressed() then
                 if msg.GetIndex() = 1
                     password = screen.GetText()
                     if password <> "" then 
                        login(emailId, password)
                     else 
                        passwordError()
                     end if
                 else if msg.GetIndex() = 2
                     'return -1
					 exit while
                 endif
             endif
         endif
     end while 
 End Function 
 
Function emailError()
     titleError = "Email can not be blank"
     textError = "Please Enter Your Email"
     returnBack = -1
     ShowMessageDialog(titleError, textError, returnBack)   
End Function


Function passwordError()
     titleError = "Password can not be blank"
     textError = "Please Enter Your Password"
     returnBack = -2
     ShowMessageDialog(titleError, textError, returnBack)   
End Function
 
 
Function ShowMessageDialog(titleError as String, textError as String, returnBack as Integer)
    port = CreateObject("roMessagePort")
    dialog = CreateObject("roMessageDialog")
    dialog.SetMessagePort(port) 
    dialog.SetTitle(titleError)
    dialog.SetText(textError)
 
    dialog.AddButton(1, "OK")
    'dialog.AddButton(1, "Cancel")
    dialog.EnableBackButton(true)
    dialog.Show()
    While True
        dlgMsg = wait(0, dialog.GetMessagePort())
        If type(dlgMsg) = "roMessageDialogEvent"
            if dlgMsg.isButtonPressed()
                if dlgMsg.GetIndex() = 1
                    exit while
                else if dlgMsg.GetIndex() = 2
                    'return -1
					exit while
                end if
            else if dlgMsg.isScreenClosed()
						'return -1
						exit while
                exit while
            end if
        end if
    end while 
End Function