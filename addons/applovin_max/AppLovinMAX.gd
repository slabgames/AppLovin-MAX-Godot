##
##  AppLovinMAX.gd
##  AppLovin MAX Godot Plugin
##
##  Created by Christopher Cong on 09/13/23.
##  Copyright © 2023 AppLovin. All rights reserved.
##

## AppLovin MAX Godot Plugin API

#class_name AppLovinMAX
extends Node
## Returns the plugin version
var version: String = "1.0.3"
## This class allows you to provide user or app data that will improve how we target ads.
var targeting_data: TargetingData = TargetingData.new()
## User segments allow us to serve ads using custom-defined rules based on which segment the user is in. For now, we only support a custom string 32 alphanumeric characters or less as the user segment.
var user_segment: UserSegment = UserSegment.new()

var _banner_ad_listener: AdEventListener
var _mrec_ad_listener: AdEventListener
var _interstitial_ad_listener: InterstitialAdEventListener
var _appopen_ad_listener: AppOpenAdEventListener
var _rewarded_ad_listener: RewardedAdEventListener
var _init_listener: InitializationListener = null

var _plugin = _get_plugin("AppLovinMAXGodotPlugin")

signal on_sdk_init

signal on_banner_clicked
signal on_banner_loaded
signal on_banner_load_failed
signal on_banner_revenue_paid
signal on_banner_expanded
signal on_banner_collapsed

signal on_mrec_clicked
signal on_mrec_loaded
signal on_mrec_load_failed
signal on_mrec_revenue_paid
signal on_mrec_expanded
signal on_mrec_collapsed

signal on_appopen_clicked
signal on_appopen_loaded
signal on_appopen_load_failed
signal on_appopen_displayed
signal on_appopen_display_failed
signal on_appopen_hidden
signal on_appopen_revenue_paid
signal on_appopen_revenue_expanded
signal on_appopen_revenue_collapsed

signal on_inter_clicked
signal on_inter_loaded
signal on_inter_load_failed
signal on_inter_displayed
signal on_inter_display_failed
signal on_inter_hidden
signal on_inter_revenue_expanded
signal on_inter_revenue_collapsed
signal on_inter_revenue_paid

signal on_rewarded_loaded
signal on_rewarded_clicked
signal on_rewarded_load_failed
signal on_rewarded_displayed
signal on_rewarded_display_failed
signal on_rewarded_hidden
signal on_rewarded_revenue_expanded
signal on_rewarded_revenue_collapsed
signal on_rewarded_revenue_paid
signal on_get_rewarded
	
class InitializationListener:
	func on_sdk_initialized(sdk_configuration : SdkConfiguration):
		pass
	
	
class AdEventListener:
	func on_ad_loaded(ad_unit_identifier: String, ad_info: Dictionary):
		print (AdInfo.new(ad_info))
		pass
	func on_ad_load_failed(ad_unit_identifier: String, error_info: Dictionary):
		print (ErrorInfo.new(error_info))

	func on_ad_clicked(ad_unit_identifier: String, ad_info: Dictionary):
		print (AdInfo.new(ad_info))
		pass

	func on_ad_revenue_paid(ad_unit_identifier: String, ad_info: Dictionary):
		print (AdInfo.new(ad_info))
		pass
		

	func on_ad_expanded(ad_unit_identifier: String, ad_info: Dictionary):
		print(AdInfo.new(ad_info))

	func on_ad_collapsed(ad_unit_identifier: String, ad_info: Dictionary):
		print(AdInfo.new(ad_info))

	
	
class FullscreenAdEventListener:
	extends AdEventListener
	
	func on_ad_displayed(ad_unit_identifier: String, ad_info: Dictionary):
		print("Full screen ad displayed. ", AdInfo.new(ad_info))
		pass
	func on_ad_display_failed(ad_unit_identifier: String, ad_info: Dictionary):
		print("Full screen ad display failed. ", AdInfo.new(ad_info))
	func on_ad_hidden(ad_unit_identifier: String, ad_info: Dictionary):
		print("Full screen ad hidden. ", AdInfo.new(ad_info))
		pass

	
	
class BannerAdEventListener:
	extends AdEventListener


class MRecAdEventListener:
	extends AdEventListener

	
class InterstitialAdEventListener:
	extends FullscreenAdEventListener
	
	
class AppOpenAdEventListener:
	extends FullscreenAdEventListener
		
	
class RewardedAdEventListener:
	extends FullscreenAdEventListener
	
	func on_ad_received_reward(ad_unit_identifier: String, reward: Reward, ad_info: Dictionary):
		emit_signal("on_get_rewarded",ad_unit_identifier,reward.label,reward.amount)
		print("on ad received reward. ", AdInfo.new(ad_info))



func _ready():
	initialize("",InitializationListener.new())
	
func initialize(sdk_key: String, listener: InitializationListener = null, ad_unit_identifiers: Array = Array()) -> void:
	if _plugin == null:
		return
	
	_init_listener = listener
	_plugin.connect("on_sdk_initialized", self, "on_sdk_initialized")
		
	_plugin.initialize(sdk_key, _generate_metadata(), ad_unit_identifiers)
	
	

func on_sdk_initialized(sdk_configuration: Dictionary):
	if _init_listener:
		_init_listener.on_sdk_initialized(SdkConfiguration.create(sdk_configuration))
	emit_signal("on_sdk_init")
#	SdkConfiguration.create(sdk_configuration)
	print("MAX SDK INITIALIZED")
	
func is_initialized() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_initialized()
	
	
func show_mediation_debugger() -> void:
	if _plugin == null:
		return
	
	_plugin.show_mediation_debugger()
	

func show_creative_debugger() -> void:
	if _plugin == null:
		return
	
	_plugin.show_creative_debugger()
	
	
func set_user_id(user_id: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_user_id(user_id)


func get_sdk_configuration() -> SdkConfiguration:
	if _plugin == null:
		return null
			
	var configuration = _plugin.get_sdk_configuration();	
	return SdkConfiguration.create(configuration);


func get_ad_value(ad_unit_identifier: String, key: String) -> String:
	if _plugin == null:
		return ""
	
	var value = _plugin.get_ad_value(ad_unit_identifier, key)
	return value if value else ""


func is_tablet() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_tablet()
	
	
func is_physical_device() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_physical_device()
	

### Privacy ###
	
func set_has_user_consent(has_user_consent: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_has_user_consent(has_user_consent)
	
	
func get_has_user_consent() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.get_has_user_consent()
	
	
func is_user_consent_set() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_user_consent_set()
	
	
func set_is_age_restricted_user(is_age_restricted_user: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_is_age_restricted_user(is_age_restricted_user)
	
	
func is_age_restricted_user() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_age_restricted_user()
	
	
func is_age_restricted_user_set() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_age_restricted_user_set()
	
	
func set_do_not_sell(do_not_sell: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_do_not_sell(do_not_sell)
	
	
func get_do_not_sell() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.get_do_not_sell()
	
	
func is_do_not_sell_set() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_do_not_sell_set()
	
	
### Banners ###

func set_banner_ad_listener() -> void:
	_plugin.connect("banner_on_ad_loaded", self, "banner_on_ad_loaded")
	_plugin.connect("banner_on_ad_load_failed", self, "banner_on_ad_load_failed")
	_plugin.connect("banner_on_ad_clicked", self,"banner_on_ad_clicked")
	_plugin.connect("banner_on_ad_revenue_paid", self, "banner_on_ad_revenue_paid")
	_plugin.connect("banner_on_ad_expanded", self, "banner_on_ad_expanded")
	_plugin.connect("banner_on_ad_collapsed", self, "banner_on_ad_collapsed")

func banner_on_ad_loaded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_banner_loaded")

func banner_on_ad_load_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_banner_load_failed")

func banner_on_ad_clicked(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_banner_clicked")

func banner_on_ad_revenue_paid(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_banner_revenue_paid")
	
func banner_on_ad_expanded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_banner_expanded")

func banner_on_ad_collapsed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_banner_collapsed")


func create_banner(ad_unit_identifier: String, banner_position) -> void:
	if _plugin == null:
		return
	
	_plugin.create_banner(ad_unit_identifier, get_adview_position(banner_position).to_lower())
	set_banner_ad_listener()


func create_banner_xy(ad_unit_identifier: String, x: float, y: float) -> void:
	if _plugin == null:
		return
		
	_plugin.create_banner_xy(ad_unit_identifier, x, y)


func load_banner(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.load_banner(ad_unit_identifier)


func set_banner_placement(ad_unit_identifier: String, placement: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_banner_placement(ad_unit_identifier, placement)


func start_banner_auto_refresh(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.start_banner_auto_refresh(ad_unit_identifier)


func stop_banner_auto_refresh(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.stop_banner_auto_refresh(ad_unit_identifier)



func update_banner_position(ad_unit_identifier: String, banner_position) -> void:
	if _plugin == null:
		return
		
	_plugin.update_banner_position(ad_unit_identifier, get_adview_position(banner_position).to_lower())


func update_banner_position_xy(ad_unit_identifier: String, x: float, y: float) -> void:
	if _plugin == null:
		return
		
	_plugin.update_banner_position_xy(ad_unit_identifier, x, y)


func set_banner_width(ad_unit_identifier: String, width: float) -> void:
	if _plugin == null:
		return
		
	_plugin.set_banner_width(ad_unit_identifier, width)


func show_banner(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.show_banner(ad_unit_identifier)


func destroy_banner(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.destroy_banner(ad_unit_identifier)


func hide_banner(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.hide_banner(ad_unit_identifier)


func set_banner_background_color(ad_unit_identifier: String, hex_color_code_string: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_banner_background_color(ad_unit_identifier, hex_color_code_string)


func set_banner_extra_parameter(ad_unit_identifier: String, key: String, value: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_banner_extra_parameter(ad_unit_identifier, key, value)


func set_banner_local_extra_parameter(ad_unit_identifier: String, key: String, value: Object) -> void:
	if _plugin == null:
		return
		
	_plugin.set_banner_local_extra_parameter(ad_unit_identifier, key, value)


func set_banner_custom_data(ad_unit_identifier: String, custom_data: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_banner_custom_data(ad_unit_identifier, custom_data)


func get_adaptive_banner_height(width: float) -> float:
	if _plugin == null:
		return 0.0
		
	return _plugin.get_adaptive_banner_height(width)
	

### MREC ###

func set_mrec_ad_listener() -> void:
	_plugin.connect("mrec_on_ad_loaded", self, "mrec_on_ad_loaded")
	_plugin.connect("mrec_on_ad_load_failed", self, "mrec_on_ad_load_failed")
	_plugin.connect("mrec_on_ad_clicked", self, "mrec_on_ad_clicked")
	_plugin.connect("mrec_on_ad_revenue_paid",self, "mrec_on_ad_revenue_paid")
	_plugin.connect("mrec_on_ad_expanded", self, "mrec_on_ad_expanded")
	_plugin.connect("mrec_on_ad_collapsed", self, "mrec_on_ad_collapsed")
	

func mrec_on_ad_loaded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_mrec_loaded")

func mrec_on_ad_load_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_mrec_load_failed")

func mrec_on_ad_clicked(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_mrec_clicked")

func mrec_on_ad_revenue_paid(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_mrec_revenue_paid")
	
func mrec_on_ad_expanded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_mrec_expanded")

func mrec_on_ad_collapsed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_mrec_collapsed")

func create_mrec(ad_unit_identifier: String, mrec_position) -> void:
	if _plugin == null:
		return
	
	_plugin.create_mrec(ad_unit_identifier, get_adview_position(mrec_position).to_lower())
	set_mrec_ad_listener()


func create_mrec_xy(ad_unit_identifier: String, x: float, y: float) -> void:
	if _plugin == null:
		return
		
	_plugin.create_mrec_xy(ad_unit_identifier, x, y)


func load_mrec(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.load_mrec(ad_unit_identifier)


func set_mrec_placement(ad_unit_identifier: String, placement: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_mrec_placement(ad_unit_identifier, placement)


func start_mrec_auto_refresh(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.start_mrec_auto_refresh(ad_unit_identifier)


func stop_mrec_auto_refresh(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.stop_mrec_auto_refresh(ad_unit_identifier)



func update_mrec_position(ad_unit_identifier: String, mrec_position) -> void:
	if _plugin == null:
		return
		
	_plugin.update_mrec_position(ad_unit_identifier, get_adview_position(mrec_position).to_lower())


func update_mrec_position_xy(ad_unit_identifier: String, x: float, y: float) -> void:
	if _plugin == null:
		return
		
	_plugin.update_mrec_position_xy(ad_unit_identifier, x, y)
	
	
func show_mrec(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.show_mrec(ad_unit_identifier)


func destroy_mrec(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.destroy_mrec(ad_unit_identifier)


func hide_mrec(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.hide_mrec(ad_unit_identifier)


func set_mrec_extra_parameter(ad_unit_identifier: String, key: String, value: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_mrec_extra_parameter(ad_unit_identifier, key, value)


func set_mrec_local_extra_parameter(ad_unit_identifier: String, key: String, value: Object) -> void:
	if _plugin == null:
		return
		
	_plugin.set_mrec_local_extra_parameter(ad_unit_identifier, key, value)


func set_mrec_custom_data(ad_unit_identifier: String, custom_data: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_mrec_custom_data(ad_unit_identifier, custom_data)
	
	
### Interstitials ###

func set_interstitial_ad_listener() -> void:
	_plugin.connect("interstitial_on_ad_loaded", self, "interstitial_on_ad_loaded")
	_plugin.connect("interstitial_on_ad_load_failed", self, "interstitial_on_ad_load_failed")
	_plugin.connect("interstitial_on_ad_clicked", self, "interstitial_on_ad_clicked")
	_plugin.connect("interstitial_on_ad_revenue_paid", self, "interstitial_on_ad_revenue_paid")
	_plugin.connect("interstitial_on_ad_displayed", self, "interstitial_on_ad_displayed")
	_plugin.connect("interstitial_on_ad_display_failed", self, "interstitial_on_ad_display_failed")
	_plugin.connect("interstitial_on_ad_hidden", self, "interstitial_on_ad_hidden")
	
	
func interstitial_on_ad_loaded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_loaded")

func interstitial_on_ad_load_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_load_failed")

func interstitial_on_ad_clicked(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_clicked")

func interstitial_on_ad_revenue_paid(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_revenue_paid")
	
func interstitial_on_ad_displayed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_displayed")

func interstitial_on_ad_display_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_display_failed")

func interstitial_on_ad_hidden(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_inter_hidden")

func load_interstitial(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
	
	set_interstitial_ad_listener()
	_plugin.load_interstitial(ad_unit_identifier)
	
	
	
func is_interstitial_ready(ad_unit_identifier: String) -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_interstitial_ready(ad_unit_identifier)

	
func show_interstitial(ad_unit_identifier: String, placement: String = "", custom_data: String = "") -> void:
	if _plugin == null:
		return
		
	_plugin.show_interstitial(ad_unit_identifier, placement, custom_data)
	
	
func set_interstitial_extra_parameter(ad_unit_identifier: String, key: String, value: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_interstitial_extra_parameter(ad_unit_identifier, key, value)


func set_interstitial_local_extra_parameter(ad_unit_identifier: String, key: String, value: Object) -> void:
	if _plugin == null:
		return
		
	_plugin.set_interstitial_local_extra_parameter(ad_unit_identifier, key, value)
	
	
### App Open ###

func set_appopen_ad_listener() -> void:
	_plugin.connect("appopen_on_ad_loaded", self, "appopen_on_ad_loaded")
	_plugin.connect("appopen_on_ad_load_failed", self, "appopen_on_ad_load_failed")
	_plugin.connect("appopen_on_ad_clicked", self, "appopen_on_ad_clicked")
	_plugin.connect("appopen_on_ad_revenue_paid", self, "appopen_on_ad_revenue_paid")
	_plugin.connect("appopen_on_ad_displayed", self, "appopen_on_ad_displayed") 
	_plugin.connect("appopen_on_ad_display_failed",self,"appopen_on_ad_display_failed") 
	_plugin.connect("appopen_on_ad_hidden", self, "appopen_on_ad_hidden")

func appopen_on_ad_loaded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_loaded")
func appopen_on_ad_load_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_load_failed")
func appopen_on_ad_clicked(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_clicked")
func appopen_on_ad_revenue_paid(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_revenue_paid")
func appopen_on_ad_displayed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_displayed")
func appopen_on_ad_display_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_display_failed")
func appopen_on_ad_hidden(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_appopen_hidden")


func load_appopen_ad(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
		
	_plugin.load_appopen_ad(ad_unit_identifier)
	set_appopen_ad_listener()
	
	
func is_appopen_ad_ready(ad_unit_identifier: String) -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_appopen_ad_ready(ad_unit_identifier)

	
func show_appopen_ad(ad_unit_identifier: String, placement: String = "", custom_data: String = "") -> void:
	if _plugin == null:
		return
		
	_plugin.show_appopen_ad(ad_unit_identifier, placement, custom_data)
	
	
func set_appopen_ad(ad_unit_identifier: String, key: String = "", value: String = "") -> void:
	if _plugin == null:
		return
		
	_plugin.set_appopen_ad_extra_parameter(ad_unit_identifier, key, value)


func set_appopen_ad_local_extra_parameter(ad_unit_identifier: String, key: String, value: Object) -> void:
	if _plugin == null:
		return
		
	_plugin.set_appopen_ad_local_extra_parameter(ad_unit_identifier, key, value)
	
	
### Rewarded ###

func set_rewarded_ad_listener() -> void:
	_plugin.connect("rewarded_on_ad_loaded", self, "rewarded_on_ad_loaded")
	_plugin.connect("rewarded_on_ad_load_failed", self, "rewarded_on_ad_load_failed")
	_plugin.connect("rewarded_on_ad_clicked", self, "rewarded_on_ad_clicked") 
	_plugin.connect("rewarded_on_ad_revenue_paid",self, "rewarded_on_ad_revenue_paid")
	_plugin.connect("rewarded_on_ad_displayed", self, "rewarded_on_ad_displayed")
	_plugin.connect("rewarded_on_ad_display_failed", self, "rewarded_on_ad_display_failed")
	_plugin.connect("rewarded_on_ad_hidden", self, "rewarded_on_ad_hidden")
	_plugin.connect("rewarded_on_ad_received_reward", self, "rewarded_on_ad_received_reward")
	

func load_rewarded_ad(ad_unit_identifier: String) -> void:
	if _plugin == null:
		return
	
	set_rewarded_ad_listener()
	_plugin.load_rewarded_ad(ad_unit_identifier)
	

func rewarded_on_ad_loaded(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_loaded")

func rewarded_on_ad_load_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_load_failed")

func rewarded_on_ad_clicked(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_clicked")

func rewarded_on_ad_revenue_paid(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_revenue_paid")
	
func rewarded_on_ad_displayed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_displayed")

func rewarded_on_ad_display_failed(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_display_failed")

func rewarded_on_ad_hidden(ad_unit_identifier: String, ad_info: Dictionary):
	emit_signal("on_rewarded_hidden")

func rewarded_on_ad_received_reward(ad_unit_identifier: String, reward: Reward, ad_info: Dictionary):
	emit_signal("on_get_rewarded",ad_unit_identifier,"reward",1)
	print("on ad received reward. ", AdInfo.new(ad_info))

func is_rewarded_ad_ready(ad_unit_identifier: String) -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_rewarded_ad_ready(ad_unit_identifier)
	
	
func show_rewarded_ad(ad_unit_identifier: String, placement: String = "", custom_data: String = "") -> void:
	if _plugin == null:
		return
		
	_plugin.show_rewarded_ad(ad_unit_identifier, placement, custom_data)
	
	
func set_rewarded_ad_extra_parameter(ad_unit_identifier: String, key: String, value: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_rewarded_ad_extra_parameter(ad_unit_identifier, key, value)


func set_rewarded_ad_local_extra_parameter(ad_unit_identifier: String, key: String, value: Object) -> void:
	if _plugin == null:
		return
		
	_plugin.set_rewarded_ad_local_extra_parameter(ad_unit_identifier, key, value)
	

### Event Tracking ###

func track_event(name: String, parameters: Dictionary) -> void:
	if _plugin == null:
		return
		
	_plugin.track_event(name, parameters)
	

### Settings ###

func set_muted(muted: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_muted(muted)
	
	
func is_muted() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_muted()
	
	
func set_verbose_logging(enabled: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_verbose_logging(enabled)
	
	
func is_verbose_logging_enabled() -> bool:
	if _plugin == null:
		return false
		
	return _plugin.is_verbose_logging_enabled()
	
	
func set_creative_debugger_enabled(enabled: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_creative_debugger_enabled(enabled)
	
	
func set_test_device_advertising_identifiers(advertising_identifiers: Array) -> void:
	if _plugin == null:
		return
		
	_plugin.set_test_device_advertising_identifiers()
	
	
func set_exception_handler_enabled(enabled: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_exception_handler_enabled(enabled)
	
	
func set_location_collection_enabled(enabled: bool) -> void:
	if _plugin == null:
		return
		
	_plugin.set_location_collection_enabled(enabled)
	
	
func set_extra_parameter(key: String, value: String) -> void:
	if _plugin == null:
		return
		
	_plugin.set_extra_parameter(key, value)
	
	
func _get_plugin(plugin_name: String) -> Object:
	if Engine.has_singleton(plugin_name):
		return Engine.get_singleton(plugin_name)

	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		printerr(plugin_name + " not found, make sure you marked all 'AppLovinMAX' plugins on export tab")

	return null
	

func _generate_metadata() -> Dictionary:
	return {
		"GodotVersion": Engine.get_version_info()
	}


#func get_rect_from_string(rect_prop_string: String) -> Rect:
#	var rect_dict = parse_json(rect_prop_string)
#	var origin_x = AppLovinMAXDictionaryUtils.get_float(rect_dict, "origin_x", 0)
#	var origin_y = AppLovinMAXDictionaryUtils.get_float(rect_dict, "origin_y", 0)
#	var width = AppLovinMAXDictionaryUtils.get_float(rect_dict, "width", 0)
#	var height = AppLovinMAXDictionaryUtils.get_float(rect_dict, "height", 0)
#	return Rect2(origin_x, origin_y, width, height)


enum AppTrackingStatus {
	UNAVAILABLE,
	NOT_DETERMINED,
	RESTRICTED,
	DENIED,
	AUTHORIZED
}


enum AdViewPosition {
	TOP_LEFT,
	TOP_CENTER,
	TOP_RIGHT,
	CENTERED,
	CENTER_LEFT,
	CENTER_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_CENTER,
	BOTTOM_RIGHT
}

func get_adview_position(adview_position) -> String:
	match adview_position:
		AdViewPosition.TOP_LEFT:
			return "TOP_LEFT"
		AdViewPosition.TOP_CENTER:
			return "TOP_CENTER"
		AdViewPosition.TOP_RIGHT:
			return "TOP_RIGHT"
		AdViewPosition.CENTERED:
			return "CENTERED"
		AdViewPosition.CENTER_LEFT:
			return "CENTER_LEFT"
		AdViewPosition.CENTER_RIGHT:
			return "CENTER_RIGHT"
		AdViewPosition.BOTTOM_LEFT:
			return "BOTTOM_LEFT"
		AdViewPosition.BOTTOM_CENTER:
			return "BOTTOM_CENTER"
		_:
			return "BOTTOM_RIGHT"


enum ErrorCode {
	UNSPECIFIED = -1,
	NO_FILL = 204,
	AD_LOAD_FAILED = -5001,
	AD_DISPLAY_FAILED = -4205,
	NETWORK_ERROR = -1000,
	NETWORK_TIMEOUT = -1001,
	NO_NETWORK = -1009,
	FULLSCREEN_AD_ALREADY_SHOWING = -23,
	FULLSCREEN_AD_NOT_READY = -24,
	NO_ACTIVITY = -5601,
	DONT_KEEP_ACTIVITIES_ENABLED = -5602
}


enum AdLoadState {
	AD_LOAD_NOT_ATTEMPTED,
	AD_LOADED,
	FAILED_TO_LOAD
}


func get_app_tracking_status(status_string: String):
	match status_string:
		"-1": 
			return AppTrackingStatus.UNAVAILABLE
		"0": 
			return AppTrackingStatus.NOT_DETERMINED
		"1": 
			return AppTrackingStatus.RESTRICTED
		"2":
			return AppTrackingStatus.DENIED
		_: 
			return AppTrackingStatus.AUTHORIZED
			

func get_app_tracking_status_string(status) -> String:
	match status:
		AppTrackingStatus.UNAVAILABLE: 
			return "UNAVAILABLE"
		AppTrackingStatus.NOT_DETERMINED: 
			return "NOT_DETERMINED"
		AppTrackingStatus.RESTRICTED: 
			return "RESTRICTED"
		AppTrackingStatus.DENIED:
			return "DENIED"
		_: 
			return "AUTHORIZED"
			

class TargetingData:
	## This enumeration represents content ratings for the ads shown to users.
	## They correspond to IQG Media Ratings.
	enum AdContentRating {
		NONE,
		ALL_AUDIENCES,
		EVERYONE_OVER_TWELVE,
		MATURE_AUDIENCES
	}

	## This enumeration represents gender.
	enum UserGender {
		UNKNOWN,
		FEMALE,
		MALE,
		OTHER
	}

	var year_of_birth: int setget set_year_of_birth
	func set_year_of_birth(value):
		if self._plugin == null:
			return
			
		AppLovinMax._plugin.set_targeting_data_year_of_birth(value)
			
			
	var gender setget set_gender
	func set_gender(value):
		if AppLovinMax._plugin == null:
			return
		
		var string_value
		match value:
			UserGender.FEMALE:
				string_value = "F"
			UserGender.MALE:
				string_value = "M"
			UserGender.OTHER:
				string_value = "O"
			_:
				string_value = ""
		AppLovinMax._plugin.set_targeting_data_gender(string_value)
			
			
	var maximum_ad_content_rating setget set_maximum_ad_content_rating
	func set_maximum_ad_content_rating(value):
		if AppLovinMax._plugin == null:
			return
		
		AppLovinMax._plugin.set_targeting_data_maximum_ad_content_rating(int(value))
		
		
	var email: String setget set_email
	func set_email(value):
		if AppLovinMax._plugin == null:
			return
		
		AppLovinMax._plugin.set_targeting_data_email(value)
			
			
	var phone_number: String setget set_phone_number
	func set_phone_number(value):
		if AppLovinMax._plugin == null:
			return
		
		AppLovinMax._plugin.set_targeting_data_phone_number(phone_number)
			
			
	var keywords: Array setget set_keywords
	func set_keywords(value):
		if AppLovinMax._plugin == null:
			return
		
		AppLovinMax._plugin.set_targeting_data_keywords(value)
		
		
	var interests: Array setget set_interests
	func set_interests(value):
		if AppLovinMax._plugin == null:
			return
		
		AppLovinMax._plugin.set_targeting_data_interests(value)


	func clear_all() -> void:
		if AppLovinMax._plugin == null:
				return
		
		AppLovinMax._plugin.clear_all_targeting_data()


class UserSegment:
	var name: String setget set_name
	func set_name(value):
		if AppLovinMax._plugin == null:
			return
	
		AppLovinMax._plugin.set_user_segment_field("name", value)


class SdkConfiguration:
	var is_successfully_initialized: bool
	var country_code: String
	var app_tracking_status
	var is_test_mode_enabled: bool


	func create_empty() -> SdkConfiguration:
		var sdk_configuration = SdkConfiguration.new()
		sdk_configuration.is_successfully_initialized = true
		var localeInfo = OS.get_locale().split("_", true)
		sdk_configuration.country_code = localeInfo[2] if localeInfo[2] != null else localeInfo[0]
		sdk_configuration.is_test_mode_enabled = false
		return sdk_configuration


	func create(event_props: Dictionary) -> SdkConfiguration:
		var sdk_configuration = SdkConfiguration.new()
		sdk_configuration.is_successfully_initialized = AppLovinMAXDictionaryUtils.get_bool(event_props, "isSuccessfullyInitialized")
		sdk_configuration.country_code = AppLovinMAXDictionaryUtils.get_string(event_props, "countryCode", "")
		sdk_configuration.is_test_mode_enabled = AppLovinMAXDictionaryUtils.get_bool(event_props, "isTestModeEnabled")

		var app_tracking_status_string = AppLovinMAXDictionaryUtils.get_string(event_props, "appTrackingStatus", "-1")
		sdk_configuration.app_tracking_status = AppLovinMax.get_app_tracking_status(app_tracking_status_string)

		return sdk_configuration
		
		
	func _to_string() -> String:
		return "[SdkConfiguration: is_successfully_initialized = " + str(is_successfully_initialized) +\
			   ", country_code = " + country_code +\
			   ", app_tracking_status = " + AppLovinMax.get_app_tracking_status_string(app_tracking_status) +\
			   ", is_test_mode_enabled = " + str(is_test_mode_enabled) + "]"


class Reward:
	var label: String
	var amount: int
	
	func _init(reward_info: Dictionary):
		label = AppLovinMAXDictionaryUtils.get_string(reward_info, "label")
		amount = AppLovinMAXDictionaryUtils.get_int(reward_info, "amount")
		

	func _to_string() -> String:
		return "Reward: " + str(amount) + " " + label


	func is_valid() -> bool:
		return label != "" and amount > 0


class WaterfallInfo:
	var name: String
	var test_name: String
	var network_responses: Array
	var latency_millies: int


	func _init(waterfall_info_dict: Dictionary):
		name = AppLovinMAXDictionaryUtils.get_string(waterfall_info_dict, "name")
		test_name = AppLovinMAXDictionaryUtils.get_string(waterfall_info_dict, "testName")
		network_responses = []
		for network_response_object in AppLovinMAXDictionaryUtils.get_list(waterfall_info_dict, "networkResponses", []):
			var network_response_dict = network_response_object as Dictionary
			var network_response = NetworkResponseInfo.new(network_response_dict)
			network_responses.append(network_response)
		latency_millies = AppLovinMAXDictionaryUtils.get_long(waterfall_info_dict, "latencyMillis")


	func _to_string() -> String:
		var network_response_strings = []
		for network_response_info in network_responses:
			network_response_strings.append(network_response_info.to_string())
		return "[MediatedNetworkInfo: name = " + name +\
			   ", testName = " + test_name +\
			   ", latency = " + str(latency_millies) +\
			   ", networkResponse = " + ", ".join(network_response_strings) + "]"


class AdInfo:
	var ad_unit_identifier: String
	var ad_format: String
	var network_name: String
	var network_placement: String
	var placement: String
	var creative_identifier: String
	var revenue: float
	var revenue_precision: String
	var waterfall_info: WaterfallInfo
	var dsp_name: String


	func _init(ad_info_dictionary: Dictionary):
		ad_unit_identifier = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "adUnitId")
		ad_format = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "adFormat")
		network_name = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "networkName")
		network_placement = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "networkPlacement")
		placement = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "placement")
		creative_identifier = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "creativeId")
		revenue = AppLovinMAXDictionaryUtils.get_double(ad_info_dictionary, "revenue", -1)
		revenue_precision = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "revenuePrecision")
		waterfall_info = WaterfallInfo.new(ad_info_dictionary["waterfallInfo"])
		dsp_name = AppLovinMAXDictionaryUtils.get_string(ad_info_dictionary, "dspName")


	func _to_string() -> String:
		return "[AdInfo adUnitIdentifier: " + ad_unit_identifier +\
			   ", adFormat: " + ad_format +\
			   ", networkName: " + network_name +\
			   ", networkPlacement: " + network_placement +\
			   ", creativeIdentifier: " + creative_identifier +\
			   ", placement: " + placement +\
			   ", revenue: " + str(revenue) +\
			   ", revenuePrecision: " + revenue_precision +\
			   ", dspName: " + dsp_name + "]"


class NetworkResponseInfo:
	var ad_load_state
	var mediated_network: MediatedNetworkInfo
	var credentials: Dictionary
	var is_bidding: bool
	var latency_millis: int
	var error: ErrorInfo


	func _init(network_response_info_dict: Dictionary):
		var mediated_network_info_dict = AppLovinMAXDictionaryUtils.get_dictionary(network_response_info_dict, "mediatedNetwork")
		mediated_network = MediatedNetworkInfo.new(mediated_network_info_dict) if mediated_network_info_dict != null else null
		credentials = AppLovinMAXDictionaryUtils.get_dictionary(network_response_info_dict, "credentials", {})
		is_bidding = AppLovinMAXDictionaryUtils.get_bool(network_response_info_dict, "isBidding")
		latency_millis = AppLovinMAXDictionaryUtils.get_long(network_response_info_dict, "latencyMillis")
		ad_load_state = AppLovinMAXDictionaryUtils.get_int(network_response_info_dict, "adLoadState")
		var error_info_dict = AppLovinMAXDictionaryUtils.get_dictionary(network_response_info_dict, "error")
		error = ErrorInfo.new(error_info_dict) if error_info_dict != null else null


	func _to_string() -> String:
		var stringBuilder = "[NetworkResponseInfo: adLoadState = " + str(ad_load_state) +\
							", mediatedNetwork = " + mediated_network.to_string() +\
							", credentials = " + str(credentials) + "]"
		match ad_load_state:
			AdLoadState.FAILED_TO_LOAD:
				stringBuilder += ", error = " + error.to_string()
			AdLoadState.AD_LOADED:
				stringBuilder += ", latency = " + str(latency_millis)
		return stringBuilder + "]"


class MediatedNetworkInfo:
	var name: String
	var adapter_class_name: String
	var adapter_version: String
	var sdk_version: String


	func _init(mediated_network_dictionary: Dictionary):
		name = AppLovinMAXDictionaryUtils.get_string(mediated_network_dictionary, "name", "")
		adapter_class_name = AppLovinMAXDictionaryUtils.get_string(mediated_network_dictionary, "adapterClassName", "")
		adapter_version = AppLovinMAXDictionaryUtils.get_string(mediated_network_dictionary, "adapterVersion", "")
		sdk_version = AppLovinMAXDictionaryUtils.get_string(mediated_network_dictionary, "sdkVersion", "")


	func to_string() -> String:
		return "[MediatedNetworkInfo name: " + name +\
			   ", adapterClassName: " + adapter_class_name +\
			   ", adapterVersion: " + adapter_version +\
			   ", sdkVersion: " + sdk_version + "]"


class ErrorInfo:
	var code
	var message: String
	var mediated_network_error_code: int
	var mediated_network_error_message: String
	var ad_load_failure_info: String
	var waterfall_info: WaterfallInfo


	func _init(error_info_dictionary: Dictionary):
		code = AppLovinMAXDictionaryUtils.get_int(error_info_dictionary, "errorCode", ErrorCode.UNSPECIFIED)
		message = AppLovinMAXDictionaryUtils.get_string(error_info_dictionary, "errorMessage", "")
		mediated_network_error_code = AppLovinMAXDictionaryUtils.get_int(error_info_dictionary, "mediatedNetworkErrorCode", int(ErrorCode.UNSPECIFIED))
		mediated_network_error_message = AppLovinMAXDictionaryUtils.get_string(error_info_dictionary, "mediatedNetworkErrorMessage", "")
		ad_load_failure_info = AppLovinMAXDictionaryUtils.get_string(error_info_dictionary, "adLoadFailureInfo", "")
		waterfall_info = WaterfallInfo.new(error_info_dictionary["waterfallInfo"]) if "waterfallInfo" in error_info_dictionary else null


	func _to_string() -> String:
		var stringbuilder = "[ErrorInfo code: " + str(code) +\
							", message: " + message
		if code == ErrorCode.AD_DISPLAY_FAILED:
			stringbuilder += ", mediatedNetworkCode: " + str(mediated_network_error_code) +\
							 ", mediatedNetworkMessage: " + mediated_network_error_message
		return stringbuilder + ", adLoadFailureInfo: " + ad_load_failure_info + "]"
		
		
