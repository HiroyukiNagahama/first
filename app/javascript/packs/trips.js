Vue.config.devtools = true;

import Vue from 'vue/dist/vue.esm.js'
import Index from '../vues/trips/index.vue'


// var head = new Vue({
//     el: '#app',
//     components: {
//         'navbar': Header,
//     }
// });
var mainTable = new Vue({

    el: '#tripList',
    components: {
        // index.html.erb に記載したtagを書く　hoge自体が書き換わる->なくなる
        'trip_table': Index
    }
})



