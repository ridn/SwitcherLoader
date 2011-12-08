include theos/makefiles/common.mk

BUNDLE_NAME = SwitcherLoaderSettings
SwitcherLoaderSettings_FILES = SwitcherLoaderSettings.mm
SwitcherLoaderSettings_INSTALL_PATH = /Library/PreferenceBundles
SwitcherLoaderSettings_FRAMEWORKS = UIKit
SwitcherLoaderSettings_PRIVATE_FRAMEWORKS = Preferences AppSupport
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitcherLoaderSettings.plist$(ECHO_END)
