// https://doc.qt.io/qtinstallerframework/scripting.html
// https://doc.qt.io/qtinstallerframework/scripting-qmlmodule.html

function Component()
{
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    if (systemInfo.kernelType === "winnt") {
        component.addOperation("CreateShortcut",
                               "@TargetDir@/SideSwap/SideSwap.exe",
                               "@UserStartMenuProgramsPath@/SideSwap.lnk",
                               "workingDirectory=@TargetDir@/SideSwap");

        component.addOperation("CreateShortcut",
                               "@TargetDir@/SideSwap/SideSwap.exe",
                               "@TargetDir@/SideSwap.lnk",
                               "workingDirectory=@TargetDir@/SideSwap");

        component.addOperation("AppendFile", "@TargetDir@/SideSwap/install.bat", "echo off\r\n %1 /quiet /norestart & exit 0");
        component.addOperation("Execute", "@TargetDir@/SideSwap/install.bat", "@TargetDir@/SideSwap/vc_redist.x64.exe");
    }
}
