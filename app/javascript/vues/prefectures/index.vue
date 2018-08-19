<template>
    <div class="row">
      <div class="col-xs-12 col-md-11">
        <input v-model="newPrefecture.name" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col-xs-2 col-md-1">
        <div class="btn-floating waves-effect waves-light red btn" v-on:click="createPrefectureAsync(newPrefecture)">
          <i class="material-icons">add</i>
        </div>
      </div>

      <table class="table table-dark">
        <thead>
        <tr>
          <td></td>
          <td>名称</td>
          <td>コード</td>
          <td>huragu</td>
          <td></td>
        </tr>
        </thead>
        <tbody>

        <tr v-for="prefecture in prefectures" v-bind:id="'row_prefecture_' + prefecture.id" class="collection-item">
          <td>
            <input type="checkbox" v-on:change="doneTask(prefecture.id)" v-bind:id="'prefecture_' + prefecture.id"/>
          </td>
          <td v-model="prefecture.name">{{ prefecture.name }}</td>
          <td v-model="prefecture.code">{{ prefecture.code }}</td>
          <td v-model="prefecture.go_flag">{{ prefecture.go_flag }}</td>
          <td>
            <a v-bind:href="'/prefectures/'+ prefecture.id ">
              <button class="btn btn-primary">
                編集だよ
              </button>
            </a>
          </td>
        </tr>

        </tbody>
      </table>
    </div>
</template>

<script>
  import axios from 'axios';

  axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
  import { mapActions } from 'vuex'

  import Multiselect from 'vue-multiselect'

  export default {
    components: {Multiselect},
    data: function () {
      return {
        prefectures: [],
        newPrefecture: {code: '', current_company_code: '', name: ''}
      }
    },
    mounted: function () {
      this.fetchUser();
      this.fetchPrefectures();
      this.fetchNewData();
    },
    methods: {
      // load時にprefecturesをセットする
      fetchUser: function() {
        axios.get('/prefectures/load_user').then((response) => {
          this.newPrefecture.code = response.data.code;
          this.newPrefecture.current_company_code = response.data.current_company_code;
        }, (error) => {
          console.log(error);
        });
      },
      fetchPrefectures: function () {
        axios.get('/prefectures/load_index').then((response) => {
          if (response.data == null) {
            return
          }
          for (var i = 0; i < response.data.length; i++) {
            this.prefectures.push(response.data[i]);
          }
          this.$store.commit('setupPrefectures', this.prefectures)
        }, (error) => {
          console.log(error);
        });
      },
      fetchNewData: function() {
        this.$store.commit('setupNewPrefecture', this.newPrefecture)
      },
      ...mapActions(
        [
          'createPrefectureAsync'
      ])

    }
  }

</script>