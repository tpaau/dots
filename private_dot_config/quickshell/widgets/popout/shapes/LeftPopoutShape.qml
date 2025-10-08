import QtQuick
import qs.widgets.popout.shapes

BasePopoutShape {
	id: root

	PathArc {
		x: Math.min(root.radius, root.width / 2)
		y: root.radius
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
		direction: PathArc.Counterclockwise
	}
	PathLine {
		x: Math.max(root.width - root.radius, root.width / 2)
		y: root.radius
	}
	PathArc {
		x: root.width
		y: 2 * root.radius
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
	}
	PathLine {
		x: root.width
		y: root.height - 2 * root.radius
	}
	PathArc {
		x: Math.max(root.width - root.radius, root.width / 2)
		y: root.height - root.radius
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
	}
	PathLine {
		x: Math.min(root.radius, root.width / 2)
		y: root.height - root.radius
	}
	PathArc {
		x: 0
		y: root.height
		radiusX: Math.min(root.radius, root.width / 2)
		radiusY: root.radius
		direction: PathArc.Counterclockwise
	}
}
