/*****************************************************************************
 *   Copyright (C) 2022 by Friedrich Schriewer <friedrich.schriewer@gmx.net> *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 ****************************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components 1.0 as KirigamiComponents
import org.kde.kcmutils as KCM

PlasmaCore.Dialog { //cosmic background noise is less random than the placement of this dialog
  id: avatarContainer

  property int avatarWidth
  property bool isTop: false

  readonly property color borderGradientColor1: plasmoid.configuration.glowColor == 0 ? "#FEAC5E" :
                                                plasmoid.configuration.glowColor == 1 ? "#a5fecb" :
                                                "#ff005d"
  readonly property color borderGradientColor2: plasmoid.configuration.glowColor == 0 ? "#C779D0" :
                                                plasmoid.configuration.glowColor == 1 ? "#20bdff" :
                                                "#ff005c"
  readonly property color borderGradientColor3: plasmoid.configuration.glowColor == 0 ? "#4BC0C8" :
                                                plasmoid.configuration.glowColor == 1 ? "#5433ff" :
                                                "#ff8b26"

  type: "Notification"

  x: root.x + root.width / 2 - width / 2
  y: root.y - width / 2 //you can't even add 1 without everything breaking wtf

  mainItem:
  Item {
   onParentChanged: {
     //This removes the dialog background
      if (parent){
        var popupWindow = Window.window
        if (typeof popupWindow.backgroundHints !== "undefined"){
          popupWindow.backgroundHints = PlasmaCore.Types.NoBackground
        }
      }
    }
  }
  Item {
    id: avatarFrame
    anchors.centerIn: parent
    width: avatarWidth
    height: avatarWidth
    KirigamiComponents.AvatarButton {
      id: mainFaceIcon
      source: kuser.faceIconUrl
      anchors {
        fill: parent
        margins: Kirigami.Units.smallSpacing
      }
      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: false
        onClicked: {
          KCM.KCMLauncher.openSystemSettings("kcm_users")
          root.toggle()
        }
      }
    }
   
    Rectangle {
      visible: plasmoid.configuration.enableGlow
      anchors.centerIn: mainFaceIcon
      width: parent.width - 4 // Subtract to prevent fringing
      height: width
      radius: width / 2
      
      gradient: Gradient {
          GradientStop { position: 0.0; color: borderGradientColor1 }
          GradientStop { position: 0.33; color: borderGradientColor2 }
          GradientStop { position: 1.0; color: borderGradientColor3 }
      }

      z:-1
      rotation: 270
      transformOrigin: Item.Center
    }
  }
}
