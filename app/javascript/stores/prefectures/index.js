import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);

import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

const state = {
  msg: 'Hello Vuex Store.',
  prefectures: [],
  newPrefecture: {code: '', current_company_code: '', name: ''}
};

const mutations = {
  setupNewPrefecture(state, value) {
    state.newPrefecture = value;
    state.newPrefecture.name = '';
  },
  addListPrefecture(state, value) {
    state.prefectures.push(value);
  },
  setupPrefectures(state, value) {
    state.prefectures = value;
  }
  // [types.UPDATE_MESSAGE](state, newMsg) {
  //     state.msg = newMsg;
  // }
};

const actions = {
  // repeat(context) {
  // let msg = context.state.msg;
  // context.commit(types.UPDATE_MESSAGE, `${msg} ${msg}`);
  // },
  createPrefectureAsync(context){
    axios.post('/prefectures/add_prefecture', { prefecture: context.state.newPrefecture }).then((response) => {
      context.commit('setupNewPrefecture', context.state.newPrefecture);
      context.commit('addListPrefecture', response.data);
    }, (error) => {
      console.log(error);
    });
  }

};

export default new Vuex.Store({
  state,
  mutations,
  actions,
});