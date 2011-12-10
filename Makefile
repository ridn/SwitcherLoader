export THEOS_DEVICE_IP=192.168.1.103
include /opt/theos/makefiles/common.mk
TWEAK_NAME = switcherloader
switcherloader_FILES = Tweak.xm SwitcherLoader.m
switcherloader_FRAMEWORKS = UIKit
switcherloader_PRIVATE_FRAMEWORKS = AppSupport

SUBPROJECTS = switcherloadersettings SLDockPlugin
include $(THEOS_MAKE_PATH)/aggregate.mk

include $(THEOS_MAKE_PATH)/library.mk

include $(THEOS_MAKE_PATH)/tweak.mk
