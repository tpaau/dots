import QtQuick
import QtQuick.Layouts
import qs.widgets

RowLayout {
	spacing: 0
	StyledIcon {
		text: ""
	}

	StyledText {
		text: Cpu.temp + "°C"
	}
}
