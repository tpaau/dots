import QtQuick
import qs.widgets.popout

BasePopoutShape {
	id: root

	PathArc {
		x: root.radius
		y: Math.min(root.radius, root.height / 2)
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
	}
	PathLine {
		x: root.radius
		y: Math.max(root.height - root.radius, root.height / 2)
	}
	PathArc {
		x: 2 * root.radius
		y: root.height
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
		direction: PathArc.Counterclockwise
	}
	PathLine {
		x: root.width - 2 * root.radius
		y: root.height
	}
	PathArc {
		x: root.width - root.radius
		y: Math.max(root.height - root.radius, root.height / 2)
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
		direction: PathArc.Counterclockwise
	}
	PathLine {
		x: root.width - root.radius
		y: Math.min(root.radius, root.height / 2)
	}
	PathArc {
		x: root.width
		radiusX: root.radius
		radiusY: Math.min(root.radius, root.height / 2)
	}
}
