import QtQuick
import qs.widgets.popout.shapes

BasePopoutShape {
	id: root

	startY: root.height

	PathArc {
		x: root.radius
		y: Math.max(root.height - root.radius, root.height / 2)
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
		direction: PathArc.Counterclockwise
	}
	PathLine {
		x: root.radius
		y: Math.min(root.radius, root.height / 2)
	}
	PathArc {
		x: 2 * root.radius
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
	}
	PathLine {
		x: root.width - 2 * root.radius
	}
	PathArc {
		x: root.width - root.radius
		y: Math.min(root.radius, root.height / 2)
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
	}
	PathLine {
		x: root.width - root.radius
		y: Math.max(root.height - root.radius, root.height / 2)
	}
	PathArc {
		x: root.width
		y: root.height
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
		direction: PathArc.Counterclockwise
	}
	PathLine {
		y: root.height
	}
}
