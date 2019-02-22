<template>
  <div class="profile">
      <router-link to="/">Back to Temp View</router-link>
      <h1>Profile Information</h1>
      <form @submit.prevent="updateProfile">
            <h2> Name: <input class="input" v-model="name"></h2>
            <h2> Location: <input class="input" v-model="sensor_location"></h2>
            <h2> Phone Number: <input class="input" v-model="phone"></h2>
            <h2> Threshold Value: <input class="input" v-model="threshold"></h2>
            <input type="submit" value="Update Profile">
      </form>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'Profile',
  data () {
    return {
      sensor_location: 'Home',
      name: '',
      phone: '8018823708',
      threshold: '70',
      baseEventUrl: "http://ryanstruthers.com:8080/sky/event/AP5Z5hn9Ex1WDmEUbj2wRz/1556/sensor/profile_updated?",
      baseCloudUrl: "http://ryanstruthers.com:8080/sky/cloud/AP5Z5hn9Ex1WDmEUbj2wRz/io.picolabs.sensor_profile/"
    }
  },
  created: function () {
               this.getProfile()
  },
  methods: {
           getProfile: function() {
                              axios.get(this.baseCloudUrl + "getProfile").then(response => {
                                      var profile = response.data
                                      console.log(profile)
                                      this.name = profile["name"]
                                      this.sensor_location = profile["location"]
                                      this.phone = profile["phone"]
                                      this.threshold = profile["threshold"]
                                      console.log(this.name)
                                      }).catch(err => {
                                      });
           },
           updateProfile: function() {
                              var params = "name=" + this.name + "&sensor_location=" + this.sensor_location + "&phone=" + this.phone + "&threshold=" + this.threshold
                              axios.get(this.baseEventUrl + params).then(response => {
                                      }).catch(err => {
                                      });
           },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.profile{
margin-right: 35%;
margin-left: 35%;
}
h2 {
    text-align: left;
}
h1, h2 {
  font-weight: normal;
}
ul {
  display: inline-block;
  list-style-type: none;
}
li {
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
