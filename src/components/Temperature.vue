<template>
  <div class="hello">
    <router-link to="/profile">Update Profile</router-link>
    <h1>Current Temperature: {{ currTemp.temperature }}&#176;F</h1>
    <ul id="allTemps">
        <h2>Recent Temperatures</h2>
        <li v-for="temp in temps">{{ temp.temperature }}&#176;F</li>
    </ul>
    <ul id="violations">
        <h2>Threshold Violations (Over {{ threshold }}&#176;F)</h2>
        <li v-for="temp in violations">{{ temp.temperature }}&#176;F</li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'Temperature',
  data () {
    return {
      currTemp: '85',
      temps: ['85', '76'],
      violations: ['85', '76'],
      time: '',
      threshold: '',
      baseUrl: "http://ryanstruthers.com:8080/sky/cloud/6vQYyAVUVUsdnz6seQiDrN/io.picolabs.temperature_store/",
      baseCloudUrl: "http://ryanstruthers.com:8080/sky/cloud/AP5Z5hn9Ex1WDmEUbj2wRz/io.picolabs.sensor_profile/"
    }
  },
  created: function () {
               this.getCurrTemp();
               this.getViolations();
               this.getTemps();
               this.getProfile();
  },
  methods: {
           getProfile: function() {
                              axios.get(this.baseCloudUrl + "getProfile").then(response => {
                                      var profile = response.data
                                      this.threshold = profile["threshold"]
                                      }).catch(err => {
                                      });
           },
           getTemps: function() {
                            axios.get(this.baseUrl + "inrange_temperatures").then(response => {
                            this.temps = response.data.reverse()
                            }).catch(err => {
                            });
           },
           getViolations: function() {
                            axios.get(this.baseUrl + "threshold_violations").then(response => {
                            this.violations = response.data.reverse()
                            }).catch(err => {
                            });
           },
           getCurrTemp: function() {
                            axios.get(this.baseUrl + "temperatures").then(response => {
                            var data = response.data
                            var lastElem = data[data.length-1]
                            this.currTemp = lastElem;
                            }).catch(err => {
                            });
           },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.hello {
margin-right: 25%;
margin-left: 25%;
}
#allTemps{
    float: left;
}
#violations {
    float: right;
}
#id {
    text-align: right;
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
