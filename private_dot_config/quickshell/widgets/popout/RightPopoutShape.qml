import QtQuick
import qs.widgets.popout

BasePopoutShape {
	id: root

	startX: width
	startY: height

	PathArc {
		x: Math.max(root.width - root.radius, root.width / 2)
		y: root.height - root.radius
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
		direction: PathArc.Counterclockwise
	}
	PathLine {
		x: Math.min(root.radius, root.width / 2)
		y: root.height - root.radius
	}
	PathArc {
		y: root.height - 2 * root.radius
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
	}
	PathLine {
		y: 2 * root.radius
	}
	PathArc {
		x: Math.min(root.radius, root.width / 2)
		y: root.radius
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
	}
	PathLine {
		x: Math.max(root.width - root.radius, root.width / 2)
		y: root.radius
	}
	PathArc {
		x: root.width
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
		direction: PathArc.Counterclockwise
	}
}
