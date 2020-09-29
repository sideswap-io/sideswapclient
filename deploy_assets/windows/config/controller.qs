// https://doc.qt.io/qtinstallerframework/noninteractive.html
// https://doc.qt.io/qtinstallerframework/scripting-qmlmodule.html

function Controller()
{
}

Controller.prototype.IntroductionPageCallback = function()
{
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false)
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false)
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false)

    var widget = gui.currentPageWidget(); // get the current wizard page
    if (widget != null) {
        widget.findChild("PackageManagerRadioButton").visible = false;
        widget.findChild("UpdaterRadioButton").visible = false;
    }
}

Controller.prototype.LicenseAgreementPageCallback = function()
{
    var widget = gui.currentPageWidget(); // get the current wizard page
    if (widget != null) {
        widget.findChild("AcceptLicenseRadioButton").checked = true;
    }
}

Controller.prototype.FinishedPageCallback = function()
{

    var widget = gui.currentPageWidget(); // get the current wizard page
    if (widget != null && installer.isInstaller() && installer.status === QInstaller.Success) {
        widget.findChild("RunItCheckBox").visible = true;
        widget.findChild("RunItCheckBox").checked = true;
        widget.findChild("RunItCheckBox").text = "Run SideSwap now.";
    }

    gui.finishButtonClicked.connect(this, function()
    {
        var widget = gui.currentPageWidget(); // get the current wizard page
        let startApp = false;
        if (widget != null) {
            startApp = widget.findChild("RunItCheckBox").checked;

        }

        if (installer.isInstaller() && installer.status === QInstaller.Success && startApp) {
            /* http://doc.qt.io/qtinstallerframework/scripting-installer.html#execute-method */
            installer.execute("@TargetDir@/SideSwap/SideSwap.exe");
        }
    });
}

