// $('.open-window').on('click',function(){
//     $('.close-window').closest('tr').remove();
//     var $clickBtn = $(this);
//     var code = $clickBtn.attr('id');
//     console.log(code)
//     $.ajax({
//         url: "prefectures/edit_ajax/?code=" + code,
//         type: "GET",
//         data: {},
//         contentType: '',
//         dataType: "html",
//         success: function(response_data) {
//             $clickBtn.closest('tr').after(response_data)
//         },
//         error: function(data) {
//             alert("errror");
//         }
//     });
// })

Vue.config.devtools = true;

import Vue from 'vue/dist/vue.esm.js'
import Vuex from 'vuex'
Vue.use(Vuex)
// prefectures stores
import store from '../stores/prefectures/index.js'
// load vue prefectures
import Index from '../vues/prefectures/index.vue'


var mainTable = new Vue({
    store,
  // data: {
  //   newPrefecture: {}
  // },
    el: '#app',
    components: {
        'prefecture_table': Index
    },
})






