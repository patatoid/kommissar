import Vue from 'vue'
import Vuex from 'vuex'

import User from '@/models/user.model'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: new User()
  },
  mutations: {
    SET_USER (state, user) {
      state.user = user
    },
    LOGOUT (state) {
      state.user.logout()
      state.user = new User()
    },
    async FETCH_USER (state) {
      state.user = await User.current()
    }
  },
  actions: {
    setUser ({ commit }, user) {
      return commit('SET_USER', user)
    },
    fetchUser ({ commit }) {
      return commit('FETCH_USER')
    },
    logout ({ commit }) {
      return commit('LOGOUT')
    }
  },
  getters: {
    currentUser (state) {
      return state.user
    }
  },
  modules: {
  }
})
