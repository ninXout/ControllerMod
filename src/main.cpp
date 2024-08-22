#include <Geode/Geode.hpp>
#include "controller.hpp"

using namespace geode::prelude;

#include <Geode/modify/PlatformToolbox.hpp>
class $modify(MyPlatformToolbox, PlatformToolbox) {
	static bool isControllerConnected() {
		return isController();
	}
};

#include <Geode/modify/MenuLayer.hpp>
class $modify(MenuLayer) {
	void onMoreGames(cocos2d::CCObject*) {
		addButtonInput(ControllerButton::A, [&](bool down) {
			log::info("{}", down ? "pressed" : "released");
		});
	}
};

#include <Geode/modify/PlayLayer.hpp>
class $modify(PlayLayer) {
	bool init(GJGameLevel* level, bool useReplay, bool dontCreateObjects) {
		if (!PlayLayer::init(level, useReplay, dontCreateObjects)) return false;

		addButtonInput(ControllerButton::A, [&](bool down) {
			static_cast<GJBaseGameLayer*>(PlayLayer::get())->handleButton(down, 1, true);
		});

		addJoystickInput(ControllerJoystick::LeftStick, [&](float x, float y) {
			if (x == 0.f) {
				static_cast<GJBaseGameLayer*>(PlayLayer::get())->handleButton(false, 2, true);
				static_cast<GJBaseGameLayer*>(PlayLayer::get())->handleButton(false, 3, true);
			}
			if (x > 0.f) {
				static_cast<GJBaseGameLayer*>(PlayLayer::get())->handleButton(true, 3, true);
			} else if (x < 0.f) {
				static_cast<GJBaseGameLayer*>(PlayLayer::get())->handleButton(true, 2, true);
			}
		});

		addButtonInput(ControllerButton::Options, [&](bool down) {
			if (down) pauseGame(true);
		});

		return true;
	}
};

#include <Geode/modify/PauseLayer.hpp>
class $modify(PauseLayer) {
	void customSetup() {
		PauseLayer::customSetup();

		addButtonInput(ControllerButton::A, [&](bool down) {
			if (down) onResume(nullptr);
		});

		addButtonInput(ControllerButton::B, [&](bool down) {
			if (down) onQuit(nullptr);
		});
	}
};