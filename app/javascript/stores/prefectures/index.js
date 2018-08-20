import Vue from 'vue';
import Vuex from 'vuex';
Vue.use(Vuex);

import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

const state = {
  msg: 'Hello Vuex Store.',
  prefectures: [],
  newPrefecture: {code: '', current_company_code: '', name: ''},
  // updatePrefecture: {code: '', area_cd: '', name: ''},
  areas: []
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
  },
  // setupUpdatePrefecture(state, value) {
  //   state.updatePrefecture = value;
  // },
  setupArea(state, value) {
    state.areas = value;
  },
  updateArea(state, value) {
    const updateObjectIndex = state.prefectures.findIndex(element => element.code === value.code)
    state.prefectures.splice(updateObjectIndex, 1, value)
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
  },
  // inline編集　v-model使用済み
  updateAreaCode({ commit }, updatePrefectureData){
    // console.log(context)
    axios.post('/prefectures/change_area_cd', { prefecture: updatePrefectureData }).then((response) => {
      commit('updateArea', response.data);
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