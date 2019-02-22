ruleset io.picolabs.sensor_profile {
  meta {
    provides getProfile
    shares getProfile
  }
  global {
   getProfile = function() {
     ent:profile.defaultsTo({"name": "Ryan", "location": "Home", "phone": "8018823708", "threshold": 70}).klog("PROFILE DATA POLLED:")
   }
  }
  
  rule profile_updated {
    select when sensor profile_updated
    pre {
      profile_data = event:attrs.klog("PROFILE UPDATED")
      name = profile_data["name"]
      location = profile_data["sensor_location"]
      phone = profile_data["phone"]
      threshold = profile_data["threshold"]
    }
    fired {
      ent:profile := {"name": name, "location": location, "phone": phone, "threshold": threshold};
      ent:name := name.klog("NAME:");
      ent:location := location.klog("LOCATION:");
      ent:phone := phone.klog("PHONE:");
      ent:threshold := threshold.klog("THRESHOLD:")
    }
  }
}
