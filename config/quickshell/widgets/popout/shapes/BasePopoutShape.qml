import QtQuick
import QtQuick.Shapes
import qs.config

ShapePath {
	property real radius
	property real width
	property real height

	pathHints: ShapePath.PathFillOnRight
		| ShapePath.PathSolid
		| ShapePath.PathNonIntersecting
	fillColor: Appearance.pallete.bg
	strokeWidth: -1
	strokeColor: Appearance.borders.color
}
