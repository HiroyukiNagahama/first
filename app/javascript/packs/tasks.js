import Vue from 'vue/dist/vue.esm.js'
import Header from '../vues/tasks/header.vue'
import Index from '../vues/tasks/index.vue'

var head = new Vue({
    el: '#app',
    components: {
      'navbar': Header,
    }
});

var app = new Vue({
    el: '#todoList',
    components: {
      // index.html.erb に記載したtagを書く　hoge自体が書き換わる->なくなる
      'hoge': Index
    }
})