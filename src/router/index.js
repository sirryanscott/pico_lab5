import Vue from 'vue'
import Router from 'vue-router'
import Temperature from '@/components/Temperature'
import Profile from '@/components/Profile'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/profile',
      name: 'Profile',
      component: Profile 
    },
    {
      path: '/',
      name: 'Temperature',
      component: Temperature
    }
  ]
})
