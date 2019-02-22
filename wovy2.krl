ruleset io.picolabs.wovyn_base2 {
  meta {
    name "Wovyn Sensor"
    description <<
Pico for Wovyn Sensor labs
>>
    author "Ryan Struthers"
   logging on
    
    use module io.picolabs.lesson_keys
    use module io.picolabs.twilio_v2 alias twilio
        with account_sid = keys:twilio{"account_sid"}
             auth_token =  keys:twilio{"auth_token"}
    
    shares messages, getThreshold, getPhone
  }
  global {
    getThreshold = function () {
      ent:temperature_threshold.defaultsTo(168)
    }
    getPhone = function() {
      ent:to.defaultsTo("8018823708")
    }
    from = 13259390035
    message = "Temperature threshold violation notification"
    
    messages = function(To, From, PageSize) {
      twilio:messages(To, From, PageSize)
    }
  }
 
  rule process_heartbeat {
    select when wovyn heartbeat
    pre {
      sensor_data = event:attrs
      temperature_data = sensor_data{["genericThing", "data", "temperature"]}
      newTemp = temperature_data[0]{"temperatureF"}
    }
    if sensor_data.isnull() then
    send_directive("Sensor Data", {"sensor_data": sensor_data})
    fired {
    }
    else {
      raise wovyn event "new_temperature_reading"
        attributes { "temperature": newTemp, "timestamp": time:now() }
      //raise sensor event "reading_reset"
    }
  }
  
  rule find_high_temps {
    select when wovyn new_temperature_reading
    pre {
      sensor_data = event:attrs
      temperature = sensor_data["temperature"]
      timestamp = sensor_data["timestamp"]
    }
    if temperature > getThreshold() then
    send_directive("Threshold Violation", {"temperature": temperature})
    fired {
      raise wovyn event "threshold_violation"
        attributes { "temperature": temperature, "timestamp": time:now() }
    }
    else {
    }
  }
  
  rule threshold_notification {
    select when wovyn threshold_violation
    twilio:send_sms(getPhone(), from, message)
  }
  
   rule profile_updated {
    select when sensor profile_updated
    pre {
      profile_data = event:attrs
      phone = profile_data["phone"]
      threshold = profile_data["threshold"]
    }
    fired {
      ent:to := phone;
      ent:temperature_threshold := threshold
    }
   }

}

