import qs.components.quickSettings
import qs.services

QSToggleButton {
	id: caffeineButton
	icon: ""
	primaryText: "Caffeine"
	secondaryText: if (Caffeine.running) {
		if (Caffeine.runIndefinitely) {
			return "On"
		}
		else {
			return "On, x left"
		}
	}
	else {
		return "Off"
	}

	toggled: Caffeine.running
	onClicked: Caffeine.running = !Caffeine.running
}
