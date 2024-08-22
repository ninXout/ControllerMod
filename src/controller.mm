#import <AppKit/AppKit.h>
#import <GameController/GameController.h>
#import <Foundation/Foundation.h>
#include <ApplicationServices/ApplicationServices.h>
#include "controller.hpp"

int controllerIndex = 0;
bool isControl = false;
std::map<int, std::function<void(bool)>> buttons = {};
std::map<int, std::function<void(float, float)>> sticks = {};

@interface CustomController : GCController
@end

void addButtonInput(int button, std::function<void(bool)> func) {
    buttons[button] = func;
}

void addJoystickInput(int button, std::function<void(float, float)> func) {
    sticks[button] = func;
}

void setupControllerControls(GCController* controller) {
    controller.extendedGamepad.valueChangedHandler = ^(GCExtendedGamepad *gamepad, GCControllerElement *element) {
        if (gamepad.leftThumbstick == element) {
            sticks[ControllerJoystick::LeftStick](gamepad.leftThumbstick.xAxis.value, gamepad.leftThumbstick.yAxis.value);
            if (gamepad.leftThumbstick.xAxis.value != 0 || gamepad.leftThumbstick.yAxis.value != 0) {

                /*CGEventRef ourEvent = CGEventCreate(NULL);
                CGPoint point = CGEventGetLocation(ourEvent);
                point.x += gamepad.leftThumbstick.xAxis.value * 10.f;
                point.y -= gamepad.leftThumbstick.yAxis.value * 10.f;
                CFRelease(ourEvent);

                CGWarpMouseCursorPosition(point);*/
            }
        }
        
        // Right Thumbstick
        if (gamepad.rightThumbstick == element) {
            if (gamepad.rightThumbstick.xAxis.value != 0) {
                NSLog(@"Controller: %ld, rightThumbstickXAxis: %f", (long)index, gamepad.rightThumbstick.xAxis.value);
            }
        }
        
        // D-Pad
        else if (gamepad.dpad == element) {
            if (gamepad.dpad.xAxis.value != 0) {
                NSLog(@"Controller: %ld, D-PadXAxis: %f", (long)index, gamepad.dpad.xAxis.value);
            } else if (gamepad.dpad.xAxis.value == 0) {
                
            }
        }
        
        // A-Button
        else if (gamepad.buttonA == element) {
            buttons[ControllerButton::A](gamepad.buttonA.value != 0);
            if (gamepad.buttonA.value != 0) {
                //NSLog(@"Controller: %ld, A-Button Pressed!", (long)index);
            }
        }
        
        // B-Button
        else if (gamepad.buttonB == element) {
            buttons[ControllerButton::B](gamepad.buttonB.value != 0);
            if (gamepad.buttonB.value != 0) {
                NSLog(@"Controller: %ld, B-Button Pressed!", (long)index);
            }
        }
        
        else if (gamepad.buttonY == element) {
            if (gamepad.buttonY.value != 0) {
                NSLog(@"Controller: %ld, Y-Button Pressed!", (long)index);
            }
        }
        
        else if (gamepad.buttonX == element) {
            if (gamepad.buttonX.value != 0) {
                NSLog(@"Controller: %ld, X-Button Pressed!", (long)index);
            }
        }

        else if (gamepad.buttonMenu == element) {
            buttons[ControllerButton::Options](gamepad.buttonMenu.value != 0);
        }
    };
}

@implementation CustomController
    - (void)connectControllers {
        for (GCController *controller in [GCController controllers]) {
            isControl = true;
            if (controller.extendedGamepad != nil) {
                controller.playerIndex = (GCControllerPlayerIndex)controllerIndex;
                controllerIndex += 1;
                setupControllerControls(controller);
            }
        }
    }

    - (void)startCheckingController {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(connectControllers) 
                                                    name:GCControllerDidConnectNotification 
                                                object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(disconnectControllers) 
                                                    name:GCControllerDidDisconnectNotification 
                                                object:nil];
    }
@end

bool isController() {
    return isControl;
}

void initController() {
    dispatch_async(dispatch_get_main_queue(), ^{
        auto rec = [[CustomController alloc] init];
        [rec startCheckingController];
    });
}