#pragma once

#include <map>

float xpos = 0.f;
float ypos = 0.f;

enum ControllerButton {
    A = 0, // X on dualshock
    B = 1, // circle on dualshock
    X = 2, // triangle on dualshock
    Y = 3, // square on dualshock
    Options = 4,
    Share = 5,
};

enum ControllerJoystick {
    LeftStick = 0,
    RightStick = 1
};

void addButtonInput(int button, std::function<void(bool)> func);
void addJoystickInput(int button, std::function<void(float, float)> func);
bool isController();
__attribute__((constructor)) void initController();