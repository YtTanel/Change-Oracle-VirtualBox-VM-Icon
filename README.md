# Change Virtual Machine Icon in Oracle VirtualBox
Made a Powershell script that allows you to change your Virtual Machine icon in Oracle VirtualBox using a simple GUI instead of a command line.

![image](https://github.com/user-attachments/assets/3dac9bc9-dd99-4c2f-8864-a327f1343670)


# Setup
Download script to get started.

### Ways to run it 
1. Right click on the file and click *Run with PowerShell*

![image](https://github.com/user-attachments/assets/ea849f03-e7ed-4c33-8f8c-4025818c8e91)

2. Open PowerShell, go to the directory where the file is located and run command:
```
& '.\Change Virtual Machine Icon.ps1'
```

# GUI

![image](https://github.com/user-attachments/assets/50dcb184-d0a4-4209-8090-6e7513ce5acb)


Required parameters:
- Virtual Machine name <br>
- Image <br>

For images, VBoxManage.exe accepts .png format. You need to convert .jpeg images to .png inorder to use them as virtual machine icons.
Below is the command that will be executed when **Change Icon** button is clicked.


 
This was a little project I wanted to do, I rarely use PowerShell so this was a lot of fun :) 
