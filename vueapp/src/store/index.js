import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    enabled: false
  },
  mutations: {
    setEnabled(state, value) {
      state.enabled = value;
    }
  },
  actions: {
    toggleEnabled({ commit, state }) {
      let newState = !state.enabled;
      if (newState === true) {
        axios.post('http://bolt.local:9292/rgb');
      }
      else {
        axios.post('http://bolt.local:9292/disable');
      }
      commit('setEnabled', newState);
    }
  }
});
