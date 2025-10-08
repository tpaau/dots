import QtQuick
import QtQuick.Shapes
import qs.widgets
import qs.config

Shape {
	antialiasing: true
	layer.enabled: true
	layer.samples: Appearance.misc.layerSampling
	layer.effect: StyledShadow {}
}
